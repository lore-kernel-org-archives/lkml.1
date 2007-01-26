Return-Path: <linux-kernel-owner+w=401wt.eu-S1030756AbXAZRER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030756AbXAZRER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030865AbXAZRER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:04:17 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:60503 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030861AbXAZREP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:04:15 -0500
Date: Fri, 26 Jan 2007 09:04:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Allow huge page allocations to use GFP_HIGH_MOVABLE
In-Reply-To: <Pine.LNX.4.64.0701261649040.23091@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0701260903110.6966@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234558.28809.21103.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260832260.6141@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261649040.23091@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Mel Gorman wrote:

> Because Andrew has made it pretty clear he will not take those patches on the
> grounds of complexity - at least until it can be shown that they fix the e1000
> problem. Any improvement on the behavior of those patches such as address
> biasing to allow memory hot-remove of the higher addresses makes them even
> more complex.

What is the e1000 problem? Jumbo packet allocation via GFP_KERNEL?
