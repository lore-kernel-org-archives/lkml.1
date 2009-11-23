Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbZKWTbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbZKWTbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbZKWTbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:31:22 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:52058 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbZKWTbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:31:22 -0500
Date: Mon, 23 Nov 2009 13:30:50 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       linux-mm@kvack.org, mpm@selenic.com,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
In-Reply-To: <1259002800.5630.1.camel@penberg-laptop>
Message-ID: <alpine.DEB.2.00.0911231329560.5617@router.home>
References: <20091118181202.GA12180@linux.vnet.ibm.com>  <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>  <1258709153.11284.429.camel@laptop>  <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com>  <1258714328.11284.522.camel@laptop> 
 <4B067816.6070304@cs.helsinki.fi>  <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Pekka Enberg wrote:

> That turns out to be _very_ hard. How about something like the following
> untested patch which delays slab_destroy() while we're under nc->lock.

Code changes to deal with a diagnostic issue?
