Return-Path: <linux-kernel-owner+w=401wt.eu-S1422657AbXCGJ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422657AbXCGJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422655AbXCGJ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:29:24 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:51858 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422660AbXCGJ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:29:23 -0500
To: akpm@linux-foundation.org
CC: npiggin@suse.de, miklos@szeredi.hu, mingo@elte.hu, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       a.p.zijlstra@chello.nl
In-reply-to: <20070307012638.793d9a9f.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 7 Mar 2007 01:26:38 -0800)
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes
 nonlinear)
References: <20070221023656.6306.246.sendpatchset@linux.site>
	<20070221023735.6306.83373.sendpatchset@linux.site>
	<20070306225101.f393632c.akpm@linux-foundation.org>
	<20070307070853.GB15877@wotan.suse.de>
	<20070307081948.GA9563@wotan.suse.de>
	<20070307082755.GA25733@elte.hu>
	<E1HOrfO-0008AW-00@dorka.pomaz.szeredi.hu>
	<20070307004709.432ddf97.akpm@linux-foundation.org>
	<E1HOrsL-0008Dv-00@dorka.pomaz.szeredi.hu>
	<20070307010756.b31c8190.akpm@linux-foundation.org>
	<20070307091823.GA8609@wotan.suse.de> <20070307012638.793d9a9f.akpm@linux-foundation.org>
Message-Id: <E1HOsS7-0008Ky-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 Mar 2007 10:28:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > But I think we discovered that those msync changes are bogus anyway
> > becuase there is a small race window where pte could be dirtied without
> > page being set dirty?
> 
> Dunno, I don't recall that.  We dirty the page before the pte...

That's the one I just submitted a fix for ;)

  http://lkml.org/lkml/2007/3/6/308

Miklos
