Return-Path: <linux-kernel-owner+w=401wt.eu-S965524AbXCGUZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524AbXCGUZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965624AbXCGUZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:25:55 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41006 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965524AbXCGUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:25:54 -0500
Date: Wed, 7 Mar 2007 12:25:51 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andres Salomon <dilinger@debian.org>
cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: don't use ZONE_DMA unless CONFIG_ZONE_DMA is set in
 setup.c
In-Reply-To: <45EE42BC.6030209@debian.org>
Message-ID: <Pine.LNX.4.64.0703071224470.24546@schroedinger.engr.sgi.com>
References: <45EDFEDB.3000507@debian.org> <20070306175246.b1253ec3.akpm@linux-foundation.org>
 <20070307040248.GA30278@redhat.com> <45EE42BC.6030209@debian.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Andres Salomon wrote:

> It would've been nice to see the ZONE_DMA removal patches just #define
> ZONE_DMA regardless, and include less #ifdefs scattered about; but at
> this point, I'd just as soon prefer to see a proper way to allocate
> things based on address constraints (as discussed in
> http://www.gelato.unsw.edu.au/archives/linux-ia64/0609/19036.html).

Would you be willing to work on that? I can sent you a bunch of unfinished 
patches if you have the time.
