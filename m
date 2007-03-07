Return-Path: <linux-kernel-owner+w=401wt.eu-S1161334AbXCGIwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161334AbXCGIwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161335AbXCGIwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:52:54 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:40104 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161334AbXCGIwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:52:54 -0500
To: akpm@linux-foundation.org
CC: mingo@elte.hu, npiggin@suse.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
In-reply-to: <20070307004709.432ddf97.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 7 Mar 2007 00:47:09 -0800)
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes
 nonlinear)
References: <20070221023656.6306.246.sendpatchset@linux.site>
	<20070221023735.6306.83373.sendpatchset@linux.site>
	<20070306225101.f393632c.akpm@linux-foundation.org>
	<20070307070853.GB15877@wotan.suse.de>
	<20070307081948.GA9563@wotan.suse.de>
	<20070307082755.GA25733@elte.hu>
	<E1HOrfO-0008AW-00@dorka.pomaz.szeredi.hu> <20070307004709.432ddf97.akpm@linux-foundation.org>
Message-Id: <E1HOrsL-0008Dv-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 Mar 2007 09:51:57 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Dirty page accounting doesn't work either on
> > non-linear mappings
> 
> It doesn't?  Confused - these things don't have anything to do with each
> other do they?

Look in page_mkclean().  Where does it handle non-linear mappings?

Miklos
