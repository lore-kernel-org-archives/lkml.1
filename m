Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYFWKeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYFWKeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYFWKdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:33:51 -0400
Received: from ns2.suse.de ([195.135.220.15]:39511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbYFWKdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:33:50 -0400
Date: Mon, 23 Jun 2008 12:33:44 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/5] x86: use BOOTMEM_EXCLUSIVE on 32-bit
Message-ID: <20080623123344.0c16ed69@kopernikus.site>
In-Reply-To: <20080623080940.GA23313@elte.hu>
References: <20080622185327.348377223@mini.kroah.org>
	<20080622190131.GB20141@suse.de>
	<87prq9dxst.fsf@skyscraper.fehenstaub.lan>
	<20080622203047.GC20800@suse.de>
	<alpine.LFD.1.10.0806221336010.2926@woody.linux-foundation.org>
	<20080623080940.GA23313@elte.hu>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
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

* Ingo Molnar <mingo@elte.hu> [2008-06-23 10:09]:

> 
> | commit 91d48fc80f22817332170082e10de60a75851640
> | Author: Bernhard Walle <bwalle@suse.de>
> | Date:   Sun Jun 8 15:46:29 2008 +0200
> | CommitDate: Tue Jun 10 14:41:56 2008 +0200
> |
> |    bootmem: add return value to reserve_bootmem_node()
> |
> |    This patch changes the function reserve_bootmem_node() from void to
> |    int, returning -ENOMEM if the allocation fails.
> |
> |    Signed-off-by: Bernhard Walle <bwalle@suse.de>
> |    Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> so it is a -stable candidate just as much as the kexec fix. (These are 
> all fixes for long-standing problems so i guess it can go all the way 
> back to all stable kernels that are being maintained.)

Ingo, 

shouldn't we add the reserve_bootmem_generic() fix [1] to 2.6.26-* at
least?


Bernhard

[1] 62b5ebe062c2801f6d40480ae3b91a64c8c8e6cb
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
