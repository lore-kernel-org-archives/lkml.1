Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbXDIWDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbXDIWDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXDIWDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:03:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44740 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753025AbXDIWDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:03:20 -0400
Date: Mon, 9 Apr 2007 15:03:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ak@suse.de,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [QUICKLIST 1/4] Quicklists for page table pages V5
In-Reply-To: <20070409144107.21287fb8.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704091501230.2761@schroedinger.engr.sgi.com>
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
 <20070409144107.21287fb8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007, Andrew Morton wrote:

> On Mon,  9 Apr 2007 11:25:09 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > Quicklists for page table pages V5
> 
> So... we skipped i386 this time?
> 
> I'd have gone squeamish if it was included, due to the mystery crash when
> we (effectively) set the list size to zero.  Someone(tm) should look into 
> that - who knows, it might indicate a problem in generic code.

Yeah too many scary monsters in the i386 arch code. Maybe Bill Irwin can 
take a look at how to make this work? He liked the benchmarking code that 
I posted so he may have the tools to insure that it works right. Maybe he 
can figure out some additional tricks on how to make quicklists work 
better?

