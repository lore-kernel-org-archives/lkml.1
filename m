Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZBWQmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZBWQmC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:42:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbZBWQlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:41:47 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:34042 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754548AbZBWQlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:41:47 -0500
Date: Mon, 23 Feb 2009 11:33:00 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 04/20] Convert gfp_zone() to use a table of precalculated
 value
In-Reply-To: <20090223163322.GN6740@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0902231130280.3333@qirst.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-5-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0902231003090.7298@qirst.com> <20090223163322.GN6740@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Mel Gorman wrote:

> I was concerned with mispredictions here rather than the actual assembly
> and gfp_zone is inlined so it's lot of branches introduced in a lot of paths.

The amount of speculation that can be done by the processor pretty
limited to a few instructions. So the impact of a misprediction also
should be minimal. The decoder is likely to have sucked in the following
code anyways.

