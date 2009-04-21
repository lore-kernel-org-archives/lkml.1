Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZDUIOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZDUIOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZDUIN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:13:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40148 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbZDUIN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:13:57 -0400
Subject: Re: [PATCH 00/25] Cleanup and optimise the page allocator V6
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
In-Reply-To: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
Date: Tue, 21 Apr 2009 11:13:54 +0300
Message-Id: <1240301634.771.64.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 23:19 +0100, Mel Gorman wrote:
> Here is V6 of the cleanup and optimisation of the page allocator and it
> should be ready for wider testing. Please consider a possibility for
> merging as a Pass 1 at making the page allocator faster.

The patch series is quite big. Can we fast-track some of the less
controversial patches to make it more manageable? AFAICT, 1-4 are ready
to go in to -mm as-is.

