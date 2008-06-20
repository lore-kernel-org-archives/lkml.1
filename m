Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbYFTOGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbYFTOGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYFTOGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:06:10 -0400
Received: from ns.suse.de ([195.135.220.2]:59165 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbYFTOGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:06:09 -0400
Date: Fri, 20 Jun 2008 16:06:45 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Unify crashkernel reservation for 32 and 64 bit
Message-ID: <20080620160645.4b793593@halley.suse.de>
In-Reply-To: <20080620135847.GE8135@elte.hu>
References: <1213969102-17400-1-git-send-email-bwalle@suse.de>
	<20080620135847.GE8135@elte.hu>
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

* Ingo Molnar [2008-06-20 15:58]:
>
> also, tip/x86 has a ton of pending changes here already so your patch 
> does not apply:
> 
>  patching file arch/x86/kernel/setup.c
>  Hunk #3 FAILED at 406.
>  1 out of 3 hunks FAILED -- rejects in file arch/x86/kernel/setup.c
>  patching file arch/x86/kernel/setup_32.c
>  Hunk #1 FAILED at 429.
>  1 out of 1 hunk FAILED -- rejects in file arch/x86/kernel/setup_32.c
>  patching file arch/x86/kernel/setup_64.c
>  Hunk #1 FAILED at 244.
>  1 out of 1 hunk FAILED -- rejects in file arch/x86/kernel/setup_64.c
>  patching file include/asm-x86/setup.h
>  Hunk #1 FAILED at 8.
>  1 out of 1 hunk FAILED -- rejects in file include/asm-x86/setup.h
> 
> you can pick up tip/master via:
> 
>   http://people.redhat.com/mingo/tip.git/README

That applies here without problems.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
