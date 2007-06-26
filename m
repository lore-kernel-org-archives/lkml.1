Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbXFZTUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbXFZTUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbXFZTUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:20:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38381 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752877AbXFZTUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:20:36 -0400
Date: Tue, 26 Jun 2007 12:20:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nish Aravamudan <nish.aravamudan@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slob: poor man's NUMA support.
In-Reply-To: <29495f1d0706261217y3ba48400q7c64865082ba13df@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706261219450.20282@schroedinger.engr.sgi.com>
References: <20070619090616.GA23697@linux-sh.org> 
 <20070626002131.ff3518d4.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0706261112380.18010@schroedinger.engr.sgi.com> 
 <29495f1d0706261204x5b49511co18546443c78033fd@mail.gmail.com> 
 <Pine.LNX.4.64.0706261209170.19878@schroedinger.engr.sgi.com>
 <29495f1d0706261217y3ba48400q7c64865082ba13df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Nish Aravamudan wrote:

> Hrm, I guess the simplest looking solution is rarely the best. Could
> we add more smarts in alloc_pages_current() to make GFP_THISNODE be
> equivalent to bind_zonelist(thisnode_only_mask)? I'll keep thinking,
> maybe I'll come up with something.

Yes that is what the most recent GFP_THISNODE patch does. See V1 of the 
meoryless node patchset.


