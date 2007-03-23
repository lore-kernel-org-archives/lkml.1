Return-Path: <linux-kernel-owner+w=401wt.eu-S932796AbXCWGjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbXCWGjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 02:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbXCWGjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 02:39:32 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39641 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796AbXCWGjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 02:39:31 -0400
Date: Thu, 22 Mar 2007 22:39:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V4
Message-Id: <20070322223927.bb4caf43.akpm@linux-foundation.org>
In-Reply-To: <20070323062843.19502.19827.sendpatchset@schroedinger.engr.sgi.com>
References: <20070323062843.19502.19827.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 23:28:41 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> 1. Proven code from the IA64 arch.
> 
> 	The method used here has been fine tuned for years and
> 	is NUMA aware. It is based on the knowledge that accesses
> 	to page table pages are sparse in nature. Taking a page
> 	off the freelists instead of allocating a zeroed pages
> 	allows a reduction of number of cachelines touched
> 	in addition to getting rid of the slab overhead. So
> 	performance improves.

By how much?
