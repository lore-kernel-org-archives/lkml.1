Return-Path: <linux-kernel-owner+w=401wt.eu-S936162AbXHHSGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936162AbXHHSGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763689AbXHHSGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:06:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38462 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763044AbXHHSGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:06:11 -0400
Date: Wed, 8 Aug 2007 11:06:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Daniel Phillips <phillips@phunq.net>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
In-Reply-To: <1186557865.7182.86.camel@twins>
Message-ID: <Pine.LNX.4.64.0708081104570.12652@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>  <200708061559.41680.phillips@phunq.net>
  <Pine.LNX.4.64.0708061605400.5090@schroedinger.engr.sgi.com> 
 <200708061649.56487.phillips@phunq.net>  <Pine.LNX.4.64.0708071513290.3683@schroedinger.engr.sgi.com>
 <1186557865.7182.86.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Peter Zijlstra wrote:

> Christoph, does this all explain the situation?

Sort of. I am still very sceptical that this will work reliably. I'd 
rather look at alternate solution like fixing reclaim. Could you have a 
look at Andrew's and my comments on the slub patch?
