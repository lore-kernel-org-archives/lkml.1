Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbXKCTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbXKCTF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbXKCTFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:05:12 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38192 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbXKCTFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:05:10 -0400
Date: Sat, 3 Nov 2007 19:04:35 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711031143140.5527@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711031859340.14407@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031143140.5527@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Christoph Lameter wrote:
> On Sat, 3 Nov 2007, Hugh Dickins wrote:
> 
> > Which fixes the leakage: Objects and Partials then remain stable.
> 
> Well this code is just an optimization for a rare case.
> Your patch may not handle the debug situation the right way.

Oh?  How?

> We could just remove it.

Hmm, that does seem a possibility.  It is going to increase the
number of partials in use, but they should go away later once
they fall out of use (in a repetitive test like mine).

I'll give it a try overnight and report back then.

Hugh
