Return-Path: <linux-kernel-owner+w=401wt.eu-S1750973AbXB0Agp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750973AbXB0Agp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXB0Agp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:36:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59285
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750973AbXB0Ago (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:36:44 -0500
Date: Mon, 26 Feb 2007 16:36:42 -0800 (PST)
Message-Id: <20070226.163642.59469811.davem@davemloft.net>
To: clameter@engr.sgi.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] SLUB v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0702242234060.20557@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702242234060.20557@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@engr.sgi.com>
Date: Sat, 24 Feb 2007 22:36:26 -0800 (PST)

> V1->V2
> - Fix up various issues. Tested on i386 UP, X86_64 SMP, ia64 NUMA.
> - Provide NUMA support by splitting partial lists per node.
> - Better Slabcache merge support (now at around 50% of slabs)
> - List slabcache aliases if slabcaches are merged.
> - Updated descriptions /proc/slabinfo output

Seems to work fine on sparc64, sane the following build warning:

mm/slub.c:1470: warning: $,1rx(Bfor_all_slabs$,1ry(B defined but not used

That function needs CONFIG_SMP ifdef protection or similar.
