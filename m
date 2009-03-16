Return-Path: <linux-kernel-owner+w=401wt.eu-S1761997AbZCPSBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997AbZCPSBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761094AbZCPRzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:55:40 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:46088 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521AbZCPRzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:55:39 -0400
Date: Mon, 16 Mar 2009 12:47:35 -0400 (EDT)
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
Subject: Re: [PATCH 20/35] Use a pre-calculated value for
 num_online_nodes()
In-Reply-To: <20090316163626.GJ24293@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903161247170.17730@qirst.com>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-21-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161207500.32577@qirst.com> <20090316163626.GJ24293@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Mel Gorman wrote:

> On Mon, Mar 16, 2009 at 12:08:25PM -0400, Christoph Lameter wrote:
> > On Mon, 16 Mar 2009, Mel Gorman wrote:
> >
> > > +extern int static_num_online_nodes;
> >
> > Strange name. Could we name this nr_online_nodes or so?
> >
>
> It's to match the function name. Arguably I could also have replaced the
> implementation of num_online_nodes() with a version that uses the static
> variable.

We have nr_node_ids etc. It would be consistant with that naming.

