Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbYHZIix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbYHZIix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYHZIio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:38:44 -0400
Received: from mx1.suse.de ([195.135.220.2]:33221 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbYHZIin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:38:43 -0400
Date: Tue, 26 Aug 2008 10:38:42 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Gregory Haskins <ghaskins@novell.com>
Cc: srostedt@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH] Subject: x86: Move crashkernel reservation before
 dma32_reserve_bootmem()
Message-ID: <20080826103842.2fc95c93@halley.suse.de>
In-Reply-To: <20080825125639.26874.80623.stgit@dev.haskins.net>
References: <20080825125639.26874.80623.stgit@dev.haskins.net>
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

* Gregory Haskins [2008-08-25 08:58]:
>
>   Bernard (cc'd) sent me this patch for 26.3-rt3 to fix an issue where a kdump
>   kernel will fail to load, thereby disabling the crashdump feature.  Please
>   consider this patch for -rt4.  IIUC, this patch is already upstream in the
>   .27 series.

commit 91467bdf6e53058af13fd255375d6634ba0c70e0
Author: Bernhard Walle <bwalle@suse.de>
Date:   Fri Jul 18 19:07:53 2008 +0200



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
