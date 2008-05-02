Return-Path: <linux-kernel-owner+w=401wt.eu-S1764285AbYEBB3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764285AbYEBB3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbYEBB26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:28:58 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51504 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750963AbYEBB25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:28:57 -0400
Date: Thu, 1 May 2008 18:28:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] SLQB v2
In-Reply-To: <20080502012321.GE30768@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0805011825420.13697@schroedinger.engr.sgi.com>
References: <20080410193137.GB9482@wotan.suse.de> <20080415034407.GA9120@ubuntu>
 <20080501015418.GC15179@wotan.suse.de> <Pine.LNX.4.64.0805011226410.8738@schroedinger.engr.sgi.com>
 <20080502004325.GA30768@wotan.suse.de> <Pine.LNX.4.64.0805011813180.13527@schroedinger.engr.sgi.com>
 <20080502012321.GE30768@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008, Nick Piggin wrote:

> But overloading struct page values happens in other places too. Putting
> everything into struct page is not scalable. We could also make kmalloc

Well lets at least attempt to catch the biggest users. Also makes code 
clearer if you f.e. use page->first_page instead of page->private for 
compound pages.

kmalloc is intended to return an arbitrary type. struct page has a defined 
format that needs to be respected.

