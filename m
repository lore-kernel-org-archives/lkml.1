Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYGRJvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYGRJvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYGRJvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:51:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:37479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbYGRJvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:51:36 -0400
Date: Fri, 18 Jul 2008 11:52:13 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: akpm@linux-foundation.org, x86@kernel.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com
Subject: Re: [PATCH] x86: Move crashkernel reservation before
 dma32_reserve_bootmem()
Message-ID: <20080718115213.3c87f8f8@halley.suse.de>
In-Reply-To: <86802c440807171550t360a2a76mddb9ae45c7e9f4fb@mail.gmail.com>
References: <1216332945-17197-1-git-send-email-bwalle@suse.de>
	<86802c440807171550t360a2a76mddb9ae45c7e9f4fb@mail.gmail.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu [2008-07-17 15:50]:
>
> > +       /*
> > +        * dma32_reserve_bootmem() allocates bootmem which may conflict
> > +        * with the crashkernel command line, so do that before
> > +        */
> > +       reserve_crashkernel();
> > +
> >  #ifdef CONFIG_X86_64
> >        dma32_reserve_bootmem();
> >  #endif
> > @@ -808,7 +814,6 @@ void __init setup_arch(char **cmdline_p)
> >         */
> >        find_smp_config();
> >  #endif
> > -       reserve_crashkernel();
> >
> >        reserve_ibft_region();
> 
> Joe Jin already had another one to move dma32_reserve_bootmem later

Commit id? Current status?


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
