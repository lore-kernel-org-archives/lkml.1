Return-Path: <linux-kernel-owner+w=401wt.eu-S967249AbXG3SU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967249AbXG3SU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934592AbXG3SUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:20:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58017 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934788AbXG3SUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:20:45 -0400
Date: Mon, 30 Jul 2007 11:20:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>, Zoltan.Menyhart@bull.net,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] flush icache before set_pte() take 5. [1/2] cache flush
 in migration
In-Reply-To: <20070728151449.f3ec0ebe.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0707301120290.743@schroedinger.engr.sgi.com>
References: <20070728150319.d19f531f.kamezawa.hiroyu@jp.fujitsu.com>
 <20070728151449.f3ec0ebe.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2007, KAMEZAWA Hiroyuki wrote:

> In migration, a new page should be cache flushed before set_pte()
> in some archs which have virtually-tagged cache..
> 
> V4 -> V5:
>    * changed flush_icache_page to flush_cache_page.
> 
> Signed-Off-By: KAMEZAWA Hiruyoki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Christoph Lameter <clameter.sgi.com>
