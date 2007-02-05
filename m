Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbXBEIjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbXBEIjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 03:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbXBEIjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 03:39:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38698 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbXBEIjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 03:39:52 -0500
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0702042351040.23790@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
	 <20070203005316.eb0b4042.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
	 <1170525860.3073.1054.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com>
	 <20070203172242.e5bf2534.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com>
	 <1170576977.3073.1100.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0702042351040.23790@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 05 Feb 2007 09:39:34 +0100
Message-Id: <1170664774.3073.1236.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-04 at 23:57 -0800, Christoph Lameter wrote:
> Hmmm.. I have had no time to test this one yet but I think this should 
> work. It uses the delayed method and a new page flag PageMlocked() with 
> different semantics. Fix for page migration is also included.
> 
> Patch avoids to put new anonymous mlocked pages on the LRU. Maybe the same 
> could be done for new pagecache pages?
> 
> I still need a solution for the problem of not having enough page flag 
> bits on i386 NUMA.

I still don't get why you *really* need such a bit. 
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

