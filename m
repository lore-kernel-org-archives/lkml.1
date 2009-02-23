Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZBWNUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZBWNUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 08:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZBWNT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 08:19:57 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34199 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbZBWNT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 08:19:56 -0500
Subject: Re: [PATCH 07/20] Simplify the check on whether cpusets are a
	factor or not
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
In-Reply-To: <20090223113959.GC6740@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
	 <1235344649-18265-8-git-send-email-mel@csn.ul.ie>
	 <Pine.LNX.4.64.0902230913080.20371@melkki.cs.Helsinki.FI>
	 <1235380072.4645.0.camel@laptop> <1235380403.6216.16.camel@penberg-laptop>
	 <20090223113959.GC6740@csn.ul.ie>
Date: Mon, 23 Feb 2009 15:19:54 +0200
Message-Id: <1235395194.6216.60.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Mon, 2009-02-23 at 11:39 +0000, Mel Gorman wrote:
> An #ifdef in a function is ugly all right. Here is a slightly
> different
> version based on your suggestion. Note the definition of number_of_cpusets
> in the !CONFIG_CPUSETS case. I didn't call cpuset_zone_allowed_softwall()
> for the preferred zone in case it wasn't in the cpuset for some reason and
> we incorrectly disabled the cpuset check.
> 
> =====
> Simplify the check on whether cpusets are a factor or not
> 
> The check whether cpuset contraints need to be checked or not is complex
> and often repeated.  This patch makes the check in advance to the comparison
> is simplier to compute.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Looks good to me!

