Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYFLRUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYFLRUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYFLRT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:19:57 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42836 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753254AbYFLRT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:19:56 -0400
Date: Thu, 12 Jun 2008 10:19:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Martin Peschke <mp3@de.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu
 operations
In-Reply-To: <200806122121.09835.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0806121017010.30597@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <200806121340.29366.nickpiggin@yahoo.com.au>
 <1213263470.25502.6.camel@kitka.ibm.com> <200806122121.09835.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populating the per cpu areas on demand is a good thing especially for 
configurations with a large number of processors. If we really go to 
support 4k processor by default then we need to allocate the smallest 
amount of per cpu structures necessary. Maybe ACPI or so can tell us how 
many processors are possible and we only allocate those. But it would be 
best if the percpu structures are only allocated for actually active 
processors.

