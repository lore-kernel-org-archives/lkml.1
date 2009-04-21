Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZDUH61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZDUH61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZDUH6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:58:18 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58272 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbZDUH6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:58:17 -0400
Subject: Re: [PATCH 13/25] Inline __rmqueue_smallest()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-14-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
	 <1240266011-11140-14-git-send-email-mel@csn.ul.ie>
Date: Tue, 21 Apr 2009 10:58:15 +0300
Message-Id: <1240300695.771.54.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 23:19 +0100, Mel Gorman wrote:
> Inline __rmqueue_smallest by altering flow very slightly so that there
> is only one call site. This allows the function to be inlined without
> additional text bloat.

Quite frankly, I think these patch changelogs could use some before and
after numbers for "size mm/page_alloc.o" because it's usually the case
that kernel text shrinks when you _remove_ inlines.

