Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZENUF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZENUF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZENUFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:05:13 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:42174 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752121AbZENUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:05:12 -0400
Date: Thu, 14 May 2009 16:05:07 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Robin Holt <holt@sgi.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
In-Reply-To: <20090513152256.GM7601@sgi.com>
Message-ID: <alpine.DEB.1.10.0905141602010.1381@qirst.com>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com> <20090513120729.5885.A69D9226@jp.fujitsu.com> <20090513152256.GM7601@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not having zone reclaim on a NUMA system often means that per node
allocations will fall back. Optimized node local allocations become very
difficult for the page allocator. If the latency penalties are not
significant then this may not matter. The larger the system, the larger
the NUMA latencies become.

One possibility would be to disable zone reclaim for low node numbers.
Eanble it only if more than 4 nodes exist?



