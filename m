Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYK1Osy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYK1Osy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 09:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYK1Oso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 09:48:44 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:58104 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYK1Osn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 09:48:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=GPuJyEb8g4S0kEzq2Y6QV7CJyKUM0Fh7FJAkhq4/p/7P9KaMPM4wUonSj2P/B+Ne67
         K317VGwb1BhxPK1SYvJumU1TaXfrxNd6DANnGVYDEqw1SmEQCN6EyRzFyRlyWqRmy8ez
         Qx33WW+UXcJ4KU3nnBsOuG9f+BryxW4NYsW14=
References: <1227710025-23592-1-git-send-email-Scholz@fias.uni-frankfurt.de> <alpine.LNX.1.10.0811281509450.19853@jikos.suse.cz>
Message-Id: <D0C5E070-309C-47A9-B0D3-530E48B475FD@gmail.com>
From: Jorden Mauro <jrm8005@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
In-Reply-To: <alpine.LNX.1.10.0811281509450.19853@jikos.suse.cz>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5F136)
Mime-Version: 1.0 (iPhone Mail 5F136)
Subject: Re: [PATCH 0/1] HID: hid_apple is not used for apple alu wireless keyboards
Date: Fri, 28 Nov 2008 09:48:20 -0500
Cc: Jan Scholz <Scholz@fias.uni-frankfurt.de>,
       "jirislaby@gmail.com" <jirislaby@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tobias Mueller <Tobias_Mueller@twam.info>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Nov 28, 2008, at 9:11, Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 26 Nov 2008, Jan Scholz wrote:
>
>> While parsing 'hid_blacklist' in hid-core.c my apple alu wireless
>> keyboard is not found.  This happens because in the blacklist it
>> is declared with HID_USB_DEVICE although the keyboards are really
>> bluetooth devices.  The same holds for 'apple_devices' list in
>> hid-apple.c
>> This patch fixes it by changing HID_USB_DEVICE to
>> HID_BLUETOOTH_DEVICE in those two lists.
>
> OK, I have done some googling in addition to what Tobias and J.R. have
> written, and your patch seems to be indeed the correct thing to do for
> these three product IDs. So I have queued it in my tree for 2.6.28,
> thanks.

Jiri,

I can test this patch hopefully next week on the wireless keyboard.  
I'll let you know of any issues.

Thanks,
J.R.


>
>
> -- 
> Jiri Kosina
> SUSE Labs
