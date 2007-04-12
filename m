Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbXDLXKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbXDLXKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbXDLXKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:10:38 -0400
Received: from holomorphy.com ([66.93.40.71]:45416 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbXDLXKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:10:38 -0400
Date: Thu, 12 Apr 2007 16:10:50 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070412231050.GN2986@holomorphy.com>
References: <1.486631555@selenic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1.486631555@selenic.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 09:43:30PM -0500, Matt Mackall wrote:
> This patch series introduces /proc/pid/pagemap and /proc/kpagemap,
> which allow detailed run-time examination of process memory usage at a
> page granularity.
> The first several patches whip the page-walking code introduced for
> /proc/pid/smaps and clear_refs into a more generic form, the next
> couple make those interfaces optional, and the last two introduce the
> new interfaces, also optional.

This solves a real-life problem for Oracle system monitoring software
(specifically EM). Among the tasks it must carry out is determining
per-process memory footprint of a set of cooperating tasks (i.e. Oracle
processes). RSS is inadequate for this due to page sharing; this work
provides sufficient information to determine what EM needs.


-- wli
