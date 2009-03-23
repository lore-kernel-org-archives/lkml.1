Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbZCWNea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbZCWNea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbZCWNeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:34:20 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:45359 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZCWNeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:34:19 -0400
Date: Mon, 23 Mar 2009 09:30:26 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/25] Cleanup and optimise the page allocator V5
In-Reply-To: <20090323115213.GC6484@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903230929440.7254@qirst.com>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903201059240.3740@qirst.com> <20090320153723.GO24586@csn.ul.ie> <alpine.DEB.1.10.0903201205260.18010@qirst.com> <20090320162716.GP24586@csn.ul.ie> <alpine.DEB.1.10.0903201503040.11746@qirst.com>
 <20090323115213.GC6484@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009, Mel Gorman wrote:

> This came up again. There was some evidence when it was introduced that
> it worked and micro-benchmarks can show it to be of some use. It's
> not-obvious-enough that I'd be wary of deleting it.

Certainly there is some minimal benefit. But maybe that benefit will
vanish if you drop the doubly linked list?

