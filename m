Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbYIPRh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbYIPRh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYIPRhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:37:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:40312 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbYIPRhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:37:16 -0400
Message-ID: <48CFEE51.2070200@kernel.org>
Date: Tue, 16 Sep 2008 10:35:13 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Mark Lord <liml@rtr.ca>
Subject: Re: XFS shutting down due to IO timeout on SATA disk (pata_via for
 CX700)
References: <20080911193511.7960bc82@neptune.home>	<48CE22E5.9090403@kernel.org>	<20080915190242.58d21a8f@neptune.home>	<48CEC8F2.4040904@kernel.org> <20080916102152.3f35439f@pluto.restena.lu>
In-Reply-To: <20080916102152.3f35439f@pluto.restena.lu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 16 Sep 2008 17:36:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Bruno Prémont wrote:
> I don't have other drives of the same model, but 3 ones slightly smaller
> in size and previous generation, those are just a few months older (but
> also have way more uptime), see below for the smartctl output. I've never
> seen ATA errors on them.
> These other drives are running on AMD based platform, SB600 SATA with AHCI.

So, smartctl output seems fine.

> Just for the record, on the VIA there were no errors yet with
> 2.6.27-rc6-git3 though I ran some compiling on it. As such it *could* be
> that one of the patches pushed by Jeff helped:
>   [libata] LBA28/LBA48 off-by-one bug in ata.h
>   sata_inic162x: enable LED blinking
>   ata: duplicate variable sparse warning

The only patch which could have affected the result is the off-by-one
one; however, FLUSH timeout is a bit unexpected failure mode for the
problem.  Can you please keep the system running for a whlie and see
whether the problem occurs?

Thanks.

-- 
tejun
