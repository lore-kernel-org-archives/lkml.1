Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbYEIVZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbYEIVZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYEIVZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 17:25:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:20032 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbYEIVZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 17:25:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CYm0RTHDgAdHi6d4EYanYnPsZ/SRmKSF3pmR3xV58o624X9YhRhxkigMXxkhrSjmkNNzu/zi0JJkH1+bHBxHu6EZqIUJPuEU010vQhiC8DWREYwNO5A2Hq8YWy7eXTbkaTULbAH2a60gV0GsbzlWUyHG5VaqLM/yREsSjnlLelM=
Message-ID: <4824C11B.4090305@gmail.com>
Date: Fri, 09 May 2008 23:24:43 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, mit-devel@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: HID bus
References: <Pine.LNX.4.64.0804181333180.12972@jikos.suse.cz> <1208644696-29129-1-git-send-email-jirislaby@gmail.com> <480B2F9A.3020104@gmail.com> <Pine.LNX.4.64.0804220158560.12972@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0804220158560.12972@jikos.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2008 02:00 AM, Jiri Kosina wrote:
> On Sun, 20 Apr 2008, Jiri Slaby wrote:
> 
>> So I suppose we still need the option to let users compile all the 
>> chosen drivers into hid.

This won't work either. It wouldn't link due to multiple definitions of 
module_init, module_exit and some module tables.

> Another possible workaround is to introduce dummy "hid" module, that will 
> just depend on all other drivers with a reference to certail symbol (and 
> this could of course be optional as CONFIG_HID_COMPAT, or whatever).

Actually this may work if we load hid_dummy by request_module from hid. I have 
no other better idea.
