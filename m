Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbXKCTgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbXKCTgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbXKCTgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:36:09 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34954 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265AbXKCTgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:36:08 -0400
Date: Sat, 3 Nov 2007 19:35:29 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711031224130.5695@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711031932020.15611@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031143140.5527@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711031859340.14407@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031224130.5695@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Christoph Lameter wrote:
> On Sat, 3 Nov 2007, Hugh Dickins wrote:
> > On Sat, 3 Nov 2007, Christoph Lameter wrote:
> > > On Sat, 3 Nov 2007, Hugh Dickins wrote:
> > > 
> > > > Which fixes the leakage: Objects and Partials then remain stable.
> > > 
> > > Well this code is just an optimization for a rare case.
> > > Your patch may not handle the debug situation the right way.
> > 
> > Oh?  How?
> 
> If SLAB_DEBUG is set then your patch does not do the proper checks for the 
> object, tracing information is not written and the poisoning is not done. 
> See alloc_debug_processing().

Yup, you're right, thanks.

I'll followup that version I CC'ed to stable,
to stop it and say you'll supply a corrected version.

Hugh
