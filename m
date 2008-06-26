Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbYFZJLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbYFZJLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYFZJLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:11:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:50991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbYFZJLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:11:20 -0400
Date: Thu, 26 Jun 2008 11:11:58 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vgoyal@redhat.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove CONFIG_EXPERIMENTAL from kdump
Message-ID: <20080626111158.59ceaeff@halley.suse.de>
In-Reply-To: <20080626102803.2a1a46cd@halley.suse.de>
References: <20080625221635.GD32344@redhat.com>
	<1214465001-12338-1-git-send-email-bwalle@suse.de>
	<20080626012337.a73c91d2.akpm@linux-foundation.org>
	<20080626102803.2a1a46cd@halley.suse.de>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
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

* Bernhard Walle [2008-06-26 10:28]:
>
> * Andrew Morton [2008-06-26 01:23]:
> > >  
> > >  config PROC_VMCORE
> > >          bool "/proc/vmcore support (EXPERIMENTAL)"
> > > -        depends on PROC_FS && EXPERIMENTAL && CRASH_DUMP
> > > +        depends on PROC_FS && CRASH_DUMP
> > >  	default y
> > >          help
> > >          Exports the dump image of crashed kernel in ELF format.
> > 
> > What about powerpc, sh and ia64?
> 
> At least for ia64 I wouldn't consider it as experimental. Don't know
> about SH and PPC.

On PPC it's also quite mature (just talked with our PPC maintainer),
they are also working on relocatable kernel support for kdump.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
