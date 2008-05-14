Return-Path: <linux-kernel-owner+w=401wt.eu-S1761560AbYENJfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560AbYENJfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 05:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYENJez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 05:34:55 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:6146 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbYENJey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 05:34:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CXoDaECAnQM1/BtgseSQhV5gzyBfAOqjw+3EqB+cQDAglPp7W0gVZiqiO/Z4U0JzaOlFCrZoYuLCdYOeHbu6aOb363WSdgd4E6aZ4BZITP7gWrrfnp2JdCv7VSfSv72ZOZ734qQ0morQshDVtKu2o107TiMGdXLt6f4GFiqywGM=
Message-ID: <482AB23C.2090809@gmail.com>
Date: Wed, 14 May 2008 11:34:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, akpm@linux-foundation.org,
       Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 3/9] HID: hid, make parsing event driven
References: <1210536043-19812-1-git-send-email-jirislaby@gmail.com>	 <1210536043-19812-2-git-send-email-jirislaby@gmail.com>	 <1210536043-19812-3-git-send-email-jirislaby@gmail.com> <1210548050.16390.39.camel@violet.holtmann.net>
In-Reply-To: <1210548050.16390.39.camel@violet.holtmann.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann napsal(a):
> Hi Jiri,
> 
>> Next step for complete hid bus, this patch includes:
>> - call parser either from probe or from hid-core if there is no probe.
>> - add ll_driver structure and centralize some stuff there (open, close...)
>> - split and merge usb_hid_configure and hid_probe into several functions
>>   to allow hooks/fixes between them
> 
> has the Bluetooth HIDP changes been tested. You move a lot of code
> around and this might have side effects.

Not really. I was only to test non-hid path (i.e. input) of hidp changes. 
This is why I want it in -mm/-next for some time. If you have some (real) 
bluetooth HID devices, I would be glad if you could test it.

Thanks.
