Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZCKO27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZCKO27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZCKO2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:28:48 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:32235 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZCKO2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:28:47 -0400
Message-ID: <49B7CA96.2040302@hp.com>
Date: Wed, 11 Mar 2009 10:28:38 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Christoph Lameter <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com,
       linux-mm@kvack.org
Subject: Re: PROBLEM: kernel BUG at mm/slab.c:3002!
References: <49B68450.9000505@hp.com> <alpine.DEB.1.10.0903101339210.9350@qirst.com> <20090311022107.GB16561@wotan.suse.de>
In-Reply-To: <20090311022107.GB16561@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tue, Mar 10, 2009 at 01:40:02PM -0400, Christoph Lameter wrote:
>> Oh nice memory corruption. May have something to do with the vmap work by
>> Nick.
> 
> Hmm, it might but I can't really tell. It happens in the vmap code
> when kmallocing something, but it isn't obviously causing it AFAIKS.
> 
> Could you print out the values of the fields involved in the BUG()?
> That might give some clues...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

FYI: The current assumption is that there is a hardware issue here
resulting in corrupted memory. We are seeing some odd things in the
hardware logs (but Linux apparently is /not/ detecting anything - no bad
pages reported, for example). We tried a firmware update for the
platform, but that did not fix things.

My next steps are to see what kind of platform diagnostics are
available, and I'm also trying to acquire another system to try the
tests on (to see if they reproduce or not).

Alan
