Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbXHBSna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbXHBSna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbXHBSnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:43:23 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46838 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755982AbXHBSnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:43:22 -0400
Date: Thu, 2 Aug 2007 11:43:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [2.6 patch] mm/migrate.c: cleanups
In-Reply-To: <20070802191502.B7A6.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0708021142240.7682@schroedinger.engr.sgi.com>
References: <20070729150320.GF16817@stusta.de> <20070802191502.B7A6.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Yasunori Goto wrote:

> But, this patch is the cause of compile error of memory unplug code of
> 2.6.23-rc1-mm2. It uses putback_lru_pages(). 
> Don't make it static please... :-(

Right. But Adrian insisted since it was currently not used upstream.

So I guess you will have to revert this piece in your unplug code.

