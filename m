Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbXETLyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbXETLyf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbXETLy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:54:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:29689 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXETLy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uuoLNMKs1SMyPToJRunl17+ad9zGMs6YvbJAJh/pDFSXkq0v34IYmHIurnypxlaJ5YVuIN8UWNPM8CbGP4XaeeLxNG3Fw8JG+DKkp7uyGZF2b+4KmDJ6zYGbwVDZGQdkd0n9ZIDlCdoCB2SlbztYdFUxGdVPtMkn1j9+kAIb1a4=
Message-ID: <465036E0.9050805@gmail.com>
Date: Sun, 20 May 2007 13:54:08 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Tjenarvi Tjenarvi <tjenarvi@yahoo.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: no DRQ after issuing MULTWRITE_EXT AND PCI: Bus #0b (-#0e) is
 hidden behind transparent bridge #0a (-#0a) (try 'pci=assign-busses')
References: <647742.64243.qm@web58814.mail.re1.yahoo.com>
In-Reply-To: <647742.64243.qm@web58814.mail.re1.yahoo.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tjenarvi Tjenarvi wrote:
> These dmesg if not as Tejun said, Which he said should only libata
> drivers used to get more information.  Frankly, I don't know which one I
> have to take off in kernel configuration to comply this.  I guess the
> libata is in:
> 
> Device Drivers  --->
>  SCSI device support  --->
> 
> But,  don't know which one to take off, so that only libata driver
> compiled. Please tell me.

Please turn off Device Drivers -> ATA/ATAPi/MFM/RLL support.  I'm not
sure which ide driver is grabbing the first port.  Can you post the
original .config?

> The machine seems nothing wrong whether I used "pci=assign-busses" or
> not. But, I found another message that I don't understand in the dmesg
> whether I use "pci=assign-busses" or not, the message still occur, I
> don't know this is related or not.  The message is "PCI: If a device
> doesn't work, try "pci=routeirq".  If it helps, post a report".  Should
> I try this kernel option?

I don't think you need to pay attention to the message.

-- 
tejun
