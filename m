Return-Path: <linux-kernel-owner+w=401wt.eu-S932973AbXBERfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbXBERfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932952AbXBERfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:35:06 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:57358 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932978AbXBERfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:35:04 -0500
Date: Mon, 5 Feb 2007 09:34:40 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Matt Mackall <mpm@selenic.com>
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <20070205163847.GI16722@waste.org>
Message-ID: <Pine.LNX.4.64.0702050933410.26272@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
 <20070203005316.eb0b4042.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
 <1170525860.3073.1054.camel@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com>
 <20070203172242.e5bf2534.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com>
 <1170576977.3073.1100.camel@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0702042351040.23790@schroedinger.engr.sgi.com>
 <1170664774.3073.1236.camel@laptopd505.fenrus.org> <20070205163847.GI16722@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Matt Mackall wrote:

> 2) lazy accounting - the same as above, with the work all moved to the
> LRU sweep
> 3) accounting with an extra page flag - still needs to scan VMAs on munmap
> 
> Christoph seems to prefer the third.

No I am saying that 2 requires 3 to work reliably. The patch I posted last 
night does 2 but the approach needs page flag in order to work 
correctly.

