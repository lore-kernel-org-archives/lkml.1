Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbZBXR1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbZBXR1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758320AbZBXR1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:27:17 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:43867 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759377AbZBXR1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:27:16 -0500
Date: Tue, 24 Feb 2009 12:17:57 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/19] Do not check NUMA node ID when the caller knows
 the node is valid
In-Reply-To: <1235477835-14500-4-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0902241215460.32227@qirst.com>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie> <1235477835-14500-4-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is certainly reducing the number of branches that are inlined into
the kernel code.


Reviewed-by: Christoph Lameter <cl@linux-foundation.org>


