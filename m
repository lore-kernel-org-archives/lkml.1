Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbXCKGuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbXCKGuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 01:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933259AbXCKGuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 01:50:01 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38100 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933253AbXCKGuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 01:50:00 -0500
Date: Sat, 10 Mar 2007 22:49:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, clameter@sgi.com,
       mpm@selenic.com
Subject: Re: [SLUB 0/3] SLUB: The unqueued slab allocator V5
Message-Id: <20070310224946.f9385917.akpm@linux-foundation.org>
In-Reply-To: <20070311021009.19963.11893.sendpatchset@schroedinger.engr.sgi.com>
References: <20070311021009.19963.11893.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is this safe to think about applying yet?

We lost the leak detector feature.

It might be nice to create synonyms for PageActive, PageReferenced and
PageError, to make things clearer in the slub core.   At the expense of
making things less clear globally.  Am unsure.
