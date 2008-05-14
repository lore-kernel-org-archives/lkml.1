Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbYENJag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbYENJag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 05:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbYENJa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 05:30:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:1182 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYENJa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 05:30:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=COPJQiuJowy0qtaEvJX25ZCrz9VGsYL23YWF1mZPDLfJa01cChhj0dNIQKs+zNkg54RnZjUpa8FqW/H8nzs138CvdRjTavyxCeTwikmi90anR97qXHMoC3h3qk0390U11k5luOECObAfa7iIkQ82EM5q7A7oiHYg2sNKhYwxgvc=
Message-ID: <482AB12F.20106@gmail.com>
Date: Wed, 14 May 2008 11:30:23 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, akpm@linux-foundation.org,
       Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 2/9] HID: make a bus from hid code
References: <1210536043-19812-1-git-send-email-jirislaby@gmail.com>	 <1210536043-19812-2-git-send-email-jirislaby@gmail.com> <1210547158.16390.28.camel@violet.holtmann.net>
In-Reply-To: <1210547158.16390.28.camel@violet.holtmann.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Marcel Holtmann napsal(a):
>> +static struct hid_driver hid_generic_bt = {
>> +	.name = "hid-generic-bt",
>> +	.id_table = hid_generic_bt_ids,
>> +};
> 
> And this one to hidp_driver instead of hid_generic_bt.
> 
> Also the name "hid-generic-bt" is not okay. Call it "hidp" since that is
> the driver name. An alternative would be "hid-bluetooth". I don't like
> the "generic" part and we never used the shortcut "bt" in any sysfs
> visible file.

Thanks for comments, I fixed all those except this one. The generic- word is 
tested in the core to recognize generic drivers which bind non-blacklisted 
devices and are handled separately. Anyway I've renamed them to 
generic-bluetooth and generic-usb instead of hid-generic-{bt,usb}.

I think the generic word in the driver name is OK, so that one ordinary user 
can see, my device is handled by the generic driver without special 
processing. Would you rather see some flag or something?
