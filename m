Return-Path: <linux-kernel-owner+w=401wt.eu-S1762141AbYBHIK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762141AbYBHIK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932870AbYBHIKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:10:04 -0500
Received: from relay2.sgi.com ([192.48.171.30]:49314 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932758AbYBHIKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:10:01 -0500
Date: Fri, 8 Feb 2008 00:10:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [git pull] more SLUB updates for 2.6.25
In-Reply-To: <47AC04CD.9090407@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0802080008560.22689@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802071755580.7473@schroedinger.engr.sgi.com>
 <200802081812.22513.nickpiggin@yahoo.com.au> <47AC04CD.9090407@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Eric Dumazet wrote:

> And SLAB/SLUB allocators, even if only used from process context, want to
> disable/re-enable interrupts...

Not any more..... The new fastpath does allow avoiding interrupt 
enable/disable and we will be hopefully able to increase the scope of that 
over time.

