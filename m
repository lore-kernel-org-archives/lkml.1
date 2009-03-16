Return-Path: <linux-kernel-owner+w=401wt.eu-S1761462AbZCPS5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbZCPS5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760345AbZCPSzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:55:49 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:54174 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759443AbZCPSzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:55:47 -0400
Date: Mon, 16 Mar 2009 11:57:10 -0400 (EDT)
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
Subject: Re: [PATCH 15/35] Inline __rmqueue_fallback()
In-Reply-To: <1237196790-7268-16-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903161156450.32577@qirst.com>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-16-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Mel Gorman wrote:

> __rmqueue() is in the slow path but has only one call site. It actually
> reduces text if it's inlined.

This is modifying __rmqueue_fallback() not __rmqueue().
