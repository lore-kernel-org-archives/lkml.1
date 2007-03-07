Return-Path: <linux-kernel-owner+w=401wt.eu-S1161230AbXCGDWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161230AbXCGDWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 22:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030788AbXCGDWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 22:22:17 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47341 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030784AbXCGDWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 22:22:16 -0500
Date: Tue, 6 Mar 2007 19:22:15 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: akpm@osdl.org, Marcelo Tosatti <marcelo@kvack.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [SLUB 2/3] Large kmalloc pass through. Removal of large general
 slabs
In-Reply-To: <20070307024043.GT23311@waste.org>
Message-ID: <Pine.LNX.4.64.0703061920090.21854@schroedinger.engr.sgi.com>
References: <20070307023502.19658.39217.sendpatchset@schroedinger.engr.sgi.com>
 <20070307023513.19658.81228.sendpatchset@schroedinger.engr.sgi.com>
 <20070307024043.GT23311@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Matt Mackall wrote:

> I've been meaning to do this in SLOB as well. Perhaps it warrants
> doing in stock kmalloc? I've got a grand total of 18 of these objects
> here.

The number increases with the number numa nodes. We have had trouble with
the maximum kmalloc size before and this will get rid of it for good.
 
