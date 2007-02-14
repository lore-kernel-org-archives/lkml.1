Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbXBNAVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbXBNAVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbXBNAVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:21:00 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51277 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbXBNAU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:20:59 -0500
Date: Wed, 14 Feb 2007 09:20:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: mbligh@mbligh.org, ak@suse.de, linux-kernel@vger.kernel.org, akpm@osdl.org,
       bob.picco@hp.com
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
Message-Id: <20070214092010.07ecc734.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0702131050340.26654@schroedinger.engr.sgi.com>
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com>
	<45D1F0B1.3020508@mbligh.org>
	<200702131845.05913.ak@suse.de>
	<Pine.LNX.4.64.0702130956540.26309@schroedinger.engr.sgi.com>
	<45D20067.2090803@mbligh.org>
	<Pine.LNX.4.64.0702131050340.26654@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 10:50:53 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 13 Feb 2007, Martin J. Bligh wrote:
> 
> > What's wrong with just setting the existing counters like
> > node_spanned_pages / node_present_pages to zero?
> 
> Will this fix the breakage that Kame-san saw?
> 

Now, memory-less-node's presetn_pages and spanned_pages are zero.
and zone's present_pages is  zero, too.

We added populated_zone(zone) macro. This can check a zone has pages or not.
(see build_zonelist in page_alloc.c)

-Kame

