Return-Path: <linux-kernel-owner+w=401wt.eu-S965719AbXAZQdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965719AbXAZQdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965721AbXAZQdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:33:55 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:37375 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965719AbXAZQdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:33:54 -0500
Date: Fri, 26 Jan 2007 08:33:45 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Allow huge page allocations to use GFP_HIGH_MOVABLE
In-Reply-To: <20070125234558.28809.21103.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0701260832260.6141@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234558.28809.21103.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unmovable allocations in the movable zone. Yuck. Why dont you abandon the 
whole concept of statically sized movable zone and go back to the nice 
earlier idea of dynamically assigning MAX_ORDER chunks to be movable or not?
