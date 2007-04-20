Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbXDTBPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbXDTBPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 21:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXDTBPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 21:15:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47607 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753011AbXDTBPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 21:15:07 -0400
Date: Thu, 19 Apr 2007 18:15:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Chinner <dgc@sgi.com>
cc: Adam Litke <aglitke@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>
Subject: Re: [RFC 4/8] Enhance fallback functions in libs to support higher
 order pages
In-Reply-To: <20070419225011.GK32602149@melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0704191814230.14874@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com>
 <a0a62dfc0704191148v15434469kc3130821cb251072@mail.gmail.com>
 <Pine.LNX.4.64.0704191208340.12936@schroedinger.engr.sgi.com>
 <20070419225011.GK32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, David Chinner wrote:

> I think PAGE_CACHE_SIZE is a redundant define with these
> modifications.  The page cache size in now variable and it is based
> on a multiple of PAGE_SIZE. Hence I suggest that PAGE_CACHE_SIZE and
> it's derivitives should be made to go away completely with this
> change.

Ultimately we should do so but for right now lets stay on the least-
intrusive and as-clean-as-possible road.
