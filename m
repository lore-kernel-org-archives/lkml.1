Return-Path: <linux-kernel-owner+w=401wt.eu-S1759660AbZFQStS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbZFQStS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbZFQStH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:49:07 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:36123 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756222AbZFQStG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:49:06 -0400
Date: Wed, 17 Jun 2009 14:48:36 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       riel@redhat.com, fengguang.wu@intel.com, linuxram@us.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/3] Fix malloc() stall in zone_reclaim() and bring
 behaviour more in line with expectations V3
In-Reply-To: <20090617190204.99C6.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0906171447510.30060@gentwo.org>
References: <20090616134423.GD14241@csn.ul.ie> <alpine.DEB.1.10.0906161049180.26093@gentwo.org> <20090617190204.99C6.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, KOSAKI Motohiro wrote:

> hm, At least major two zone reclaim developer disagree my patch. Thus I have to
> agree with you, because I really don't hope to ignore other developer's opnion.
>
> So, as far as I understand, the conclusion of this thread are
>   - Drop my patch
>   - instead, implement improvement patch of (may_unmap && page_mapped()) case
>   - the documentation should be changed
>   - it's my homework(?)
>
> Can you agree this?

As far as I understand you: Yes. Unmapping can occur in more advanced zone
reclaim modes but the default needs to be as lightweight as possible.

