Return-Path: <linux-kernel-owner+w=401wt.eu-S1422779AbXBUSdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422779AbXBUSdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422782AbXBUSdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:33:32 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40036 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422779AbXBUSdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:33:31 -0500
Date: Wed, 21 Feb 2007 10:33:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jsipek@fsl.cs.sunysb.edu,
       unionfs@filesystems.org, bunk@stusta.de, hooanon05@yahoo.co.jp
Subject: Re: [PATCH 2/3] slab: export ksize to modules
In-Reply-To: <20070221081443.GC2857@rhun.haifa.ibm.com>
Message-ID: <Pine.LNX.4.64.0702211031290.24719@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702211006210.8172@sbz-30.cs.Helsinki.FI>
 <20070221081443.GC2857@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Muli Ben-Yehuda wrote:

> On Wed, Feb 21, 2007 at 10:06:52AM +0200, Pekka J Enberg wrote:
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > This exports ksize in slab and slob allocators to modules.
> 
> That's a pretty generic name... if it's going to be part of the module
> API, it should be renamed to something a bit more obvious.

Hmmm... The current names are

kmalloc
kcalloc
kzalloc
kfree
ksize

All are pretty terse and most are frequently used (except ksize and 
maybe kcalloc).

