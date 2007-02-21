Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbXBULjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbXBULjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXBULjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:39:10 -0500
Received: from tirith.ics.muni.cz ([147.251.4.36]:57814 "EHLO
	tirith.ics.muni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbXBULjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:39:08 -0500
Date: Wed, 21 Feb 2007 12:39:23 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [git patches] libata ACPI support
Message-ID: <20070221113923.GA5143@mail.muni.cz>
References: <20070220214716.GA3690@mail.muni.cz> <45DB74D9.206@garzik.org> <20070220232633.GA3598@mail.muni.cz> <45DB88FD.5020509@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45DB88FD.5020509@garzik.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 147.251.54.96
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (tirith.ics.muni.cz [147.251.4.35]); Wed, 21 Feb 2007 12:38:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 06:49:17PM -0500, Jeff Garzik wrote:
> Can you narrow down the -gitX release further?  i.e. does 2.6.20-git13 
> perform at full speed?  -git13 includes several libata changes, but does 
> not include the ACPI additions.
> 
> Since this is an ACPI execution error in the bug, that would tend to 
> point to bad BIOS tables.  But since there is a performance drop that 
> does not disappear with acpi=off, there might also be another factor, 
> unrelated to ACPI, at play here.

I have found that the issue is between git12 and git13.

I have also found another issue, not sure whether it is also presented by
git13, however in git15, IDE interrupts are no more unmasked. 

-- 
Luká¹ Hejtmánek
