Return-Path: <linux-kernel-owner+w=401wt.eu-S1030795AbXAZGgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030795AbXAZGgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030796AbXAZGgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:36:21 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:40527 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030795AbXAZGgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:36:20 -0500
Date: Thu, 25 Jan 2007 22:36:17 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Track mlock()ed pages
In-Reply-To: <45B9A00C.4040701@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0701252234490.11230@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0701252141570.10629@schroedinger.engr.sgi.com>
 <45B9A00C.4040701@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Nick Piggin wrote:

> Christoph Lameter wrote:
> > Add NR_MLOCK
> > 
> > Track mlocked pages via a ZVC
> 
> I think it is not quite right. You are tracking the number of ptes
> that point to mlocked pages, which can be >= the actual number of pages.

Mlocked pages are not inherited. I would expect sharing to be very rare.
 
> Also, page_add_anon_rmap still needs to be balanced with page_remove_rmap.

Hmmm.... 
 
> I can't think of an easy way to do this without per-page state. ie.
> another page flag.

Thats what I am trying to avoid.
