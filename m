Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbXKQLAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbXKQLAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 06:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbXKQLAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 06:00:24 -0500
Received: from mail12.tpgi.com.au ([203.12.160.162]:37406 "EHLO
	mail12.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbXKQLAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 06:00:23 -0500
X-TPG-Antivirus: Passed
Subject: Re: 2.6.24-rc2-git6: Reported regressions from 2.6.23
From: Will Trives <will@trivescon.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 17 Nov 2007 21:56:14 +1100
Message-Id: <1195296974.5149.11.camel@Athas>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject    :  cd/dvd inaccessible in 2.6.24-rc2 
> Submitter  :  Will Trives <will@trivescon.com.au> 
> References :  http://lkml.org/lkml/2007/11/9/290 
>               http://bugzilla.kernel.org/show_bug.cgi?id=9346 
> Handled-By :  Alan Cox <alan@lxorguk.ukuu.org.uk> 
>               Jeff Garzik <jeff@garzik.org>

> Not being handled by any more. 2.6.24-rc2 shows assorted IRQ delivery
> and IRQ assignment problems for IDE controllers which appear to be
> ACPI problems. Its one for the ACPI people to take a look at.
> 

I was wrong originally, the issue is acctually occuring whenever I try
to write to a cd. With wodim or k3b, I am unable to write to the drive.
The error shown in dmesg is what happened when I tried to blank a disc.
In 2.6.23 it works instantly, with 2.6.24-rc4 it sits there, then there
are those errors, then I cannot eject the dvd from the drive. With k3b
it takes an age just to load and when it does it reports no media in the
drive, I am also unable to eject the media from the drive.

I can mount a standard dvd without issue in 2.6.24-rc3. It's just
writing that fails.

