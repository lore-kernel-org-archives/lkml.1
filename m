Return-Path: <linux-kernel-owner+w=401wt.eu-S1761521AbYHENay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761521AbYHENay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 09:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759612AbYHENao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 09:30:44 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:55993 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbYHENam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 09:30:42 -0400
Date: Tue, 5 Aug 2008 09:28:59 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: full list of unused CONFIGs under drivers/
In-Reply-To: <20080805152609.1119f0b1@hskinnemo-gx745.norway.atmel.com>
Message-ID: <alpine.LFD.1.10.0808050928300.11588@localhost.localdomain>
References: <alpine.LFD.1.10.0808031737280.16642@localhost.localdomain> <20080805152609.1119f0b1@hskinnemo-gx745.norway.atmel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008, Haavard Skinnemoen wrote:

> "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> > ===== MTD_NAND_ATMEL_ECC_SOFT
> > drivers/mtd/nand/Kconfig:313:config MTD_NAND_ATMEL_ECC_SOFT
>
> It may be unreferenced, but it behaves as expected. It's part of a set
> of three mutually exclusive choices, so after checking for the two
> others, there's no point checking for the last one.
>
> Of course, we could apply the patch below ;-)

no, that's ok, i do get the occasional false positives in the list.
still tweaking those scripts.  :-)

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
