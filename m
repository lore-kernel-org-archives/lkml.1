Return-Path: <linux-kernel-owner+w=401wt.eu-S1764934AbXFST1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764934AbXFST1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbXFST1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:27:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32955 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756772AbXFST1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:27:03 -0400
Date: Tue, 19 Jun 2007 12:27:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH -mm] add a kmem_cache for nsproxy objects
In-Reply-To: <20070619190406.GA3830@infradead.org>
Message-ID: <Pine.LNX.4.64.0706191225030.7008@schroedinger.engr.sgi.com>
References: <4676F0B9.3080408@fr.ibm.com> <20070619113501.a88bba50.akpm@linux-foundation.org>
 <20070619190406.GA3830@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Christoph Hellwig wrote:

> Hmm, I must have missed the macro going in.  Frankly speaking I plain hate
> it.  It's a rather useless obsfucation.

It makes the code easier to review and reduces errors by establishing a 
standard way of defining a slab with minimal effort. You can 
still do the  old style and create the kmem_cache_create parameter 
monsters that span lots of lines.

KMEM_CACHE can do it just by specifying two parameters.

