Return-Path: <linux-kernel-owner+w=401wt.eu-S1762564AbYCCTNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762564AbYCCTNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbYCCTNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:13:40 -0500
Received: from relay1.sgi.com ([192.48.171.29]:42348 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754228AbYCCTNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:13:39 -0500
Date: Mon, 3 Mar 2008 11:13:38 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: move cache_line_size() to <linux/cache.h>
In-Reply-To: <Pine.LNX.4.64.0803031450330.27319@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0803031112440.6917@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803031450330.27319@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good idea. That also allows us to get rid of SLAB_HWCACHE_ALIGN. All users 
would have to specify cache_line_size() as the alignment instead of using 
SLAB_HWCACHE_ALIGN.

Reviewed-by: Christoph Lameter <clameter@sgi.com>

