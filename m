Return-Path: <linux-kernel-owner+w=401wt.eu-S935005AbZLPQZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935005AbZLPQZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934973AbZLPQZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:25:05 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:41614 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934910AbZLPQZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:25:03 -0500
Date: Wed, 16 Dec 2009 10:24:32 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
In-Reply-To: <20091216101107.GA15031@basil.fritz.box>
Message-ID: <alpine.DEB.2.00.0912161023300.8572@router.home>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com> <20091216101107.GA15031@basil.fritz.box>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009, Andi Kleen wrote:

> The problem is that it also slows down the writers, and we have
> some workloads where writing is the bottleneck.

There is no code change here. This is just a way to make it possible to
change mmap_sem in the future.

