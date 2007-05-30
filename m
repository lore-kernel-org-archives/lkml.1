Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbXE3UKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbXE3UKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbXE3UK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:10:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47324 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753418AbXE3UKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:10:25 -0400
Date: Wed, 30 May 2007 13:10:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] KAMEZAWA Hiroyuki - migration by kernel
In-Reply-To: <Pine.LNX.4.64.0705301304200.2671@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0705301309530.2712@schroedinger.engr.sgi.com>
References: <20070529173609.1570.4686.sendpatchset@skynet.skynet.ie>
 <20070529173649.1570.85922.sendpatchset@skynet.skynet.ie>
 <20070530114243.e3c3c75e.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0705302021040.7044@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705301304200.2671@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Christoph Lameter wrote:

> What guarantees that the old vma is not gone by then?

We would need to add the vma on the stack to the anon vma list .... Right.

