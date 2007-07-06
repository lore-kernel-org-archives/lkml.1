Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbXGFRyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbXGFRyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757809AbXGFRyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:54:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53698 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756088AbXGFRya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:54:30 -0400
Date: Fri, 6 Jul 2007 10:54:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] some kmalloc/memset ->kzalloc (tree wide)
In-Reply-To: <1183741479.7054.111.camel@twins>
Message-ID: <Pine.LNX.4.64.0707061052570.30575@schroedinger.engr.sgi.com>
References: <878x9ta320.fsf@wanadoo.fr> <1183741479.7054.111.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Peter Zijlstra wrote:

> On Fri, 2007-07-06 at 18:51 +0200, Yoann Padioleau wrote:
> > Transform some calls to kmalloc/memset to a single kzalloc (or
> > kcalloc).
> > 
> 
> Christoph, what is the plan wrt GFP_ZERO?

Its going in AFAIK. Need to resort my patches and then I will push it 
back.

kzalloc will continue to exist as a shorthand notation. So no problem with 
continuing the conversion. kmalloc with GFP_ZERO may be more advantageous 
in allocator type functionality where the caller may want to specify if 
the allocated memory should be zeroed or not.

