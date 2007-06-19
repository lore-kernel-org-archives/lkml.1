Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbXFSWrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbXFSWrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbXFSWrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:47:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbXFSWrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:47:11 -0400
Date: Tue, 19 Jun 2007 15:46:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, suresh.b.siddha@intel.com
Subject: Re: [patch 10/26] SLUB: Faster more efficient slab determination
 for __kmalloc.
Message-Id: <20070619154654.218f902c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706191533580.7633@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com>
	<20070618095915.826976488@sgi.com>
	<20070619130858.693ae66e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706191522230.7633@schroedinger.engr.sgi.com>
	<20070619152957.a03fbb2c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706191533580.7633@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 15:38:01 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> Ok and BUILD_BUG_ON really works? Had some bad experiences with it.

hm, I don't recall any problems, apart from its very obscure error
reporting.

But if it breaks, we get an opportunity to fix it ;)
