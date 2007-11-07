Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbXKGSGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbXKGSGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbXKGSGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:06:12 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41071 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755696AbXKGSGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:06:10 -0500
Date: Wed, 7 Nov 2007 10:06:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/10] define page_file_cache
In-Reply-To: <20071107093527.0d312903@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0711071005400.9000@schroedinger.engr.sgi.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
 <20071103185516.24832ab0@bree.surriel.com> <Pine.LNX.4.64.0711061821010.5249@schroedinger.engr.sgi.com>
 <20071106215552.4ab7df81@bree.surriel.com> <Pine.LNX.4.64.0711061856400.5565@schroedinger.engr.sgi.com>
 <20071106221710.3f9b8dd6@bree.surriel.com> <Pine.LNX.4.64.0711061920510.5746@schroedinger.engr.sgi.com>
 <20071107093527.0d312903@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007, Rik van Riel wrote:

> How exactly can an anonymous page ever become file backed?

When they get assigned a swap entry.

> > Do ramfs pages count as memory backed?
> 
> Since ramfs pages cannot be evicted from memory at all, they
> should go into the "noreclaim" page set.

Which LRU do they go on.

