Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbZBQPQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbZBQPQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZBQPQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:16:21 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:37484 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751073AbZBQPQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:16:21 -0500
Date: Tue, 17 Feb 2009 10:08:21 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 1/8] slab: introduce kzfree()
In-Reply-To: <20090216152751.GA27520@cmpxchg.org>
Message-ID: <alpine.DEB.1.10.0902171007010.19685@qirst.com>
References: <20090216142926.440561506@cmpxchg.org> <20090216144725.572446535@cmpxchg.org> <20090216152751.GA27520@cmpxchg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why would you want to zero an object on release? Is this for security?

Please give us some rationale for this. Do we need free on zero now for
all allocators?


