Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbXB0NOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbXB0NOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 08:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbXB0NOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:14:52 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47928 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750872AbXB0NOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:14:51 -0500
Date: Tue, 27 Feb 2007 14:16:33 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Meelis Roos <mroos@linux.ee>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
Message-ID: <20070227141633.5453982c@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.SOC.4.64.0702271459040.8348@math>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	<20070226220152.GA29575@stusta.de>
	<Pine.SOC.4.64.0702271459040.8348@math>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007 15:00:29 +0200 (EET)
Meelis Roos <mroos@linux.ee> wrote:

> > Subject    : ata-piix ACPI errors (40/80 pin cable mix)
> > References : http://lkml.org/lkml/2007/2/22/159
> > Submitter  : Meelis Roos <mroos@linux.ee>
> > Status     : unknown
> 
> Still appears, but this does not seem to be 40/80 pin cable problem to 
> be but rather ata-piix calling some acpi methods and this rulsts in acpi 
> errors.

There are two separate problems showing up in the one trace - broken ACPI
spew and wrong cable detect. I don't think they are related
