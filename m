Return-Path: <linux-kernel-owner+w=401wt.eu-S1762321AbXEKS3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbXEKS3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbXEKS26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:28:58 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754924AbXEKS26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:28:58 -0400
Date: Fri, 11 May 2007 11:27:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Remove SLAB_CTOR_CONSTRUCTOR
Message-Id: <20070511112750.9a9a2b57.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705111105180.22949@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705111105180.22949@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 11:06:41 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> SLAB_CTOR_CONSTRUCTOR is always specified. No point in checking it.
> 
> [Sorry Andrew, another one of these "touch lots of kernel files" patch. Defer
> if its not convenient.]
> 
> While we are at it: Fix bug in mtd/ubi/eba.c. Check was inverted.

hm.  I think what we do here is to merge all the bits which don't conflict
with anyone else's pending work.  That means that there will be a few
stragglers left over for a while which we'll need to clean up later on.
