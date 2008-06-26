Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbYFZI1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbYFZI1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYFZI12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:27:28 -0400
Received: from mx1.suse.de ([195.135.220.2]:52969 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbYFZI10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:27:26 -0400
Date: Thu, 26 Jun 2008 10:28:03 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Subject: Re: [PATCH] Remove CONFIG_EXPERIMENTAL from kdump
Message-ID: <20080626102803.2a1a46cd@halley.suse.de>
In-Reply-To: <20080626012337.a73c91d2.akpm@linux-foundation.org>
References: <20080625221635.GD32344@redhat.com>
	<1214465001-12338-1-git-send-email-bwalle@suse.de>
	<20080626012337.a73c91d2.akpm@linux-foundation.org>
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

* Andrew Morton [2008-06-26 01:23]:
> >  
> >  config PROC_VMCORE
> >          bool "/proc/vmcore support (EXPERIMENTAL)"
> > -        depends on PROC_FS && EXPERIMENTAL && CRASH_DUMP
> > +        depends on PROC_FS && CRASH_DUMP
> >  	default y
> >          help
> >          Exports the dump image of crashed kernel in ELF format.
> 
> What about powerpc, sh and ia64?

At least for ia64 I wouldn't consider it as experimental. Don't know
about SH and PPC. But should we mark it as EXPERIMENTAL on all
platforms only because some "exotic" (at least SH) platforms have kdump
not very long implemented?



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
