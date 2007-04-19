Return-Path: <linux-kernel-owner+w=401wt.eu-S1766905AbXDSRwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766905AbXDSRwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766909AbXDSRwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:52:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53438 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766905AbXDSRwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:52:07 -0400
Date: Thu, 19 Apr 2007 10:52:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nish Aravamudan <nish.aravamudan@gmail.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 6/8] Account for pages in the page cache in terms of base
 pages
In-Reply-To: <29495f1d0704191045u77e8d7e1g87954549b82a0306@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704191051190.12576@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
  <20070419163535.11948.91100.sendpatchset@schroedinger.engr.sgi.com>
 <29495f1d0704191045u77e8d7e1g87954549b82a0306@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Nish Aravamudan wrote:

> > NR_FILE_PAGES,
> > +                                       1 << mappig->order);
> 
> Typo? should be mapping->order?

Correct. Sigh. Why do these things creep in at the last minute before 
posting???

