Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbYG2UC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbYG2UC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYG2UCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:02:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:30465 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYG2UCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:02:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BrjZ0rbuQPYcq9iE3VHE9m9yMkppMHFN7A3VFijx43LliB290nZP7ODKb146T7vb1o
         2cXjGJxMkVWdjCmQBgn3xvpwSOyqTaKsVxX/fqJ9S1CK9T1KrHWOpp6Du3rZfmunEAV/
         WdzeGihvNwqyyrQ3L17RxAb588m0AWzUu8Sdc=
Message-ID: <488F79C6.5020202@gmail.com>
Date: Tue, 29 Jul 2008 22:12:54 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: linux-kernel@vger.kernel.org
Subject: Re: soft lockup while copying data from a FAT usb stick and consequent
 FAT table corruption
References: <488DC849.1050407@gmail.com> <871w1d1por.fsf@devron.myhome.or.jp>
In-Reply-To: <871w1d1por.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA san,

OGAWA Hirofumi wrote:
> Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> writes:
> 
>> Jul 24 19:03:10 eurasia kernel: [25075.616150] sd 0:0:0:0: [sda] Assuming drive cache: write through
>> Jul 24 19:03:10 eurasia kernel: [25075.616153]  sda: sda1
>> Jul 24 19:03:10 eurasia kernel: [25075.617510] sd 0:0:0:0: [sda] Attached SCSI removable disk
>> Jul 24 19:03:17 eurasia kernel: [25083.820927] usb 1-5: reset high speed USB device using ehci_hcd and address 2
>> Jul 24 19:03:19 eurasia kernel: [25085.483682] usb 1-5: reset high speed USB device using ehci_hcd and address 2
>> Jul 24 19:03:19 eurasia kernel: [25085.624466] sd 0:0:0:0: [sda] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
>> Jul 24 19:03:19 eurasia kernel: [25085.624466] end_request: I/O error, dev sda, sector 37
> 
> It seems I/O error of device. Do this device work if without FAT?
> E.g. read and write to device (/dev/xxx), etc.

Looks like it's the usb port, now it doesn't even get to the point to load usb-storage. If i plug it to another port 
attached to the same controller it does a couple of without errors:

dd bs=4096 count=400000 if=/dev/sda1 of=/dev/null

I can mount the filesystem but i get the same (infinite?) "FAT Directory bread(block n) failed" loop. So i suppose the 
next thing to do is to format the pen again :)

thank you,
Riccardo
