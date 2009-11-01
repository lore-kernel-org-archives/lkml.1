Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbZKAR4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbZKAR4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 12:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZKAR4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 12:56:12 -0500
Received: from xenotime.net ([72.52.64.118]:54026 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752974AbZKAR4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 12:56:12 -0500
Date: Sun, 1 Nov 2009 09:52:08 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/16] trivial: fix assorted "through" typos
Message-Id: <20091101095208.10d57e8f.rdunlap@xenotime.net>
In-Reply-To: <4AEC2971.8050105@imap.cc>
References: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com>
	<4AEC0EBE.2040308@crca.org.au>
	<4AEC2971.8050105@imap.cc>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009 13:11:29 +0100 Tilman Schmidt wrote:

> Am 31.10.2009 11:17 schrieb Nigel Cunningham:
> > I've only looked at this one, but something caught my eye...
> > 
> > André Goddard Rosa wrote:
> >> diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> >> b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> >> index f7b9cdc..b52c1f8 100644
> >> --- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> >> +++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> >> @@ -38,7 +38,7 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)
> >>
> >>  #ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
> >>  	d_cache = CPLB_L1_CHBL;
> >> -#ifdef CONFIG_BFIN_EXTMEM_WRITETROUGH
> >> +#ifdef CONFIG_BFIN_EXTMEM_WRITETHROUGH
> >>  	d_cache |= CPLB_L1_AOW | CPLB_WT;
> >>  #endif
> >>  #endif
> > 
> > "Surely that can't be the only time?", I thought. But it is - all of the
> > other #ifdefs are spelled correctly, so you're probably fixing a
> > hard-to-find bug here! Good catch!
> > 
> > Makes me wonder if anyone's written a tool to find things like this -
> > #ifdefs that will never be defined...
> 
> I seem to remember someone (Joe Perches?) did, and regularly posted
> results to LKML in the past, but at some point switched to publishing
> them on a web page instead.

It was Robert PJ Day.
See http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup


---
~Randy
