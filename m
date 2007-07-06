Return-Path: <linux-kernel-owner+w=401wt.eu-S1764304AbXGFRvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764304AbXGFRvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763766AbXGFRue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:50:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56169 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763526AbXGFRud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:50:33 -0400
Date: Fri, 6 Jul 2007 10:50:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@stusta.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mm/migrate.c: cleanups
In-Reply-To: <20070705232353.GI3492@stusta.de>
Message-ID: <Pine.LNX.4.64.0707061049530.30575@schroedinger.engr.sgi.com>
References: <20070705232353.GI3492@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Adrian Bunk wrote:

> This patch contains the following cleanups:
> - every file should include the headers containing the prototypes for
>   its global functions
> - make the needlessly global putback_lru_pages() static
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Well we may have to re-rexport putback_lru_pages() again soon because
of the hotplug / memory compaction work but until that time.

Acked-by: Christoph Lameter <clameter@sgi.com>

