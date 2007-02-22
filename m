Return-Path: <linux-kernel-owner+w=401wt.eu-S932774AbXBVGmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbXBVGmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 01:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbXBVGmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 01:42:17 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58845 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751430AbXBVGmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 01:42:16 -0500
Date: Wed, 21 Feb 2007 22:42:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Josef Sipek <jsipek@fsl.cs.sunysb.edu>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: Re: [-mm patch] UNION_FS must depend on SLAB
In-Reply-To: <45DD3574.9070801@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0702212239270.30485@schroedinger.engr.sgi.com>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
 <20070220000810.GK13958@stusta.de> <84144f020702192237k78a5045bl51e0871fb3cac253@mail.gmail.com>
 <20070220151356.GA19239@filer.fsl.cs.sunysb.edu>
 <20070221141944.af6001db.akpm@linux-foundation.org>
 <20070222020036.GE5867@filer.fsl.cs.sunysb.edu> <20070221182657.57264123.akpm@linux-foundation.org>
 <45DD3574.9070801@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Pekka Enberg wrote:

> I think we can merge krealloc without unionfs. I'll whoop up a new patch as
> per Christoph's suggestions. I think at least XFS already has its own realloc
> and there might be some other open-coded users. It's not _changing_ the slab
> as much as adding new functionality that makes sense fron a general point of
> view.

I really like the krealloc idea. Could we useful elsewhere to extend 
objects and it is similar to the realloc() available in glibc.

