Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbYGROot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbYGROot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYGROok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:44:40 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:55052 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbYGROoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:44:39 -0400
Subject: Re: [PATCH][RFC] slub: increasing order reduces memory
	usage	of	some key caches
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, mpm@selenic.com, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <4880A694.1000100@linux-foundation.org>
References: <1216211371.3122.46.camel@castor.localdomain>
	 <487DF5D4.9070101@linux-foundation.org>
	 <1216216730.3122.60.camel@castor.localdomain>
	 <487DFFBE.5050407@linux-foundation.org>
	 <1216375025.3082.7.camel@castor.localdomain>
	 <4880A694.1000100@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 15:42:57 +0100
Message-Id: <1216392177.3082.27.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-07-18 at 09:20 -0500, Christoph Lameter wrote:
> Richard Kennedy wrote:
> 
> > Slabcache: radix_tree_node       Aliases:  0 Order :  1 Objects: 33564
> 
> Argh. Should this not be the dentry cache? Wrong numbers?
> 
> 
sorry -- yes I cut & pasted the wrong set.

**2.6.26
Slabcache: dentry                Aliases:  0 Order :  0 Objects: 22553
** Reclaim accounting active

Sizes (bytes)     Slabs              Debug                Memory
------------------------------------------------------------------------
Object :     208  Total  :    1188   Sanity Checks : Off  Total: 4866048
SlabObj:     208  Full   :    1186   Redzoning     : Off  Used : 4691024
SlabSiz:    4096  Partial:       0   Poisoning     : Off  Loss :  175024
Loss   :       0  CpuSlab:       2   Tracking      : Off  Lalig:       0
Align  :       8  Objects:      19   Tracing       : Off  Lpadd:  171072

**after make
Slabcache: dentry                Aliases:  0 Order :  0 Objects: 80076
** Reclaim accounting active

Sizes (bytes)     Slabs              Debug                Memory
------------------------------------------------------------------------
Object :     208  Total  :    4215   Sanity Checks : Off  Total: 17264640
SlabObj:     208  Full   :    4205   Redzoning     : Off  Used : 16655808
SlabSiz:    4096  Partial:       8   Poisoning     : Off  Loss :  608832
Loss   :       0  CpuSlab:       2   Tracking      : Off  Lalig:       0
Align  :       8  Objects:      19   Tracing       : Off  Lpadd:  606960


