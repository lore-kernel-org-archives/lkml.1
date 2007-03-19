Return-Path: <linux-kernel-owner+w=401wt.eu-S966029AbXCSRIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966029AbXCSRIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966031AbXCSRIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:08:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59977 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966030AbXCSRIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:08:05 -0400
Date: Mon, 19 Mar 2007 10:08:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, ast@domdv.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
In-Reply-To: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0703191007230.23929@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Pekka J Enberg wrote:

> This changes kmem_cache_free() to deal with NULL objects passed to it. The 
> current behavior is inconsistent with kfree() so there are callers 
> passing NULL to kmem_cache_free().

Hmmm.. kmem_cache_free is significantly different. One also needs to 
specify the slab cache.
 
> Andreas, can you please confirm this fixes the oops you reported on 
> linux-scsi?

Could we fix the BUG instead?
