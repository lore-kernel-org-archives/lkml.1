Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZBWRNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZBWRNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZBWRND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:13:03 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:59974 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751571AbZBWRNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:13:01 -0500
Date: Mon, 23 Feb 2009 12:03:50 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 04/20] Convert gfp_zone() to use a table of precalculated
 value
In-Reply-To: <20090223164047.GO6740@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0902231203050.25810@qirst.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-5-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0902231003090.7298@qirst.com> <200902240241.48575.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0902231042440.7790@qirst.com>
 <20090223164047.GO6740@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Mel Gorman wrote:

> > Maybe we can come up with a version of gfp_zone that has no branches and
> > no lookup?
> >
>
> Ideally, yes, but I didn't spot any obvious way of figuring it out at
> compile time then or now. Suggestions?

Can we just mask the relevant bits and then find the highest set bit? With
some rearrangement of gfp flags this may work.

