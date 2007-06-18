Return-Path: <linux-kernel-owner+w=401wt.eu-S1763272AbXFRREX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763272AbXFRREX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbXFRREQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:04:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50403 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753075AbXFRREQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:04:16 -0400
Date: Mon, 18 Jun 2007 10:04:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 2/7] Allow CONFIG_MIGRATION to be set without CONFIG_NUMA
In-Reply-To: <20070618092901.7790.31240.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0706180956440.4751@schroedinger.engr.sgi.com>
References: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie>
 <20070618092901.7790.31240.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Mel Gorman wrote:

> 
> CONFIG_MIGRATION currently depends on CONFIG_NUMA. move_pages() is the only
> user of migration today and as this system call is only meaningful on NUMA,
> it makes sense. However, memory compaction will operate within a zone and is

There are more user of migration. move_pages is one of them, then there is
cpuset process migration, MPOL_BIND page migration and sys_migrate_pages 
for explicit process migration.

> useful on both NUMA and non-NUMA systems. This patch allows CONFIG_MIGRATION
> to be used in all memory models. To preserve existing behaviour, move_pages()
> is only available when CONFIG_NUMA is set.

What does this have to do with memory models? A bit unclear.

Otherwise

Acked-by: Christoph Lameter <clameter@sgi.com>

