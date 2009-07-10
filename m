Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZGJSz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZGJSz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZGJSzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:55:52 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:45977 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752859AbZGJSzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:55:51 -0400
Date: Fri, 10 Jul 2009 14:55:44 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Nick Piggin <npiggin@suse.de>
cc: David Rientjes <rientjes@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, graydon@redhat.com, fche@redhat.com
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
In-Reply-To: <20090710093825.GJ14666@wotan.suse.de>
Message-ID: <alpine.DEB.1.10.0907101453240.14152@gentwo.org>
References: <1247156020.27671.40.camel@debian-nb> <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com> <20090710084745.GA26752@elte.hu> <alpine.DEB.2.00.0907100158090.13880@chino.kir.corp.google.com> <1247217548.771.10.camel@penberg-laptop>
 <alpine.DEB.2.00.0907100223140.14601@chino.kir.corp.google.com> <20090710093825.GJ14666@wotan.suse.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, Nick Piggin wrote:

> Don't know whether it should go in as non-default or not. The plan
> is to kind of kick up a stink and make people care about the slab
> issue again rather than quietly add more slab allocators to the
> tree...
>
> Perhaps making it non-default for one release would be a good idea,
> I don't know.

Just merging it as non default could be done now as far as I can tell.
Then there may be more people working on the stabilization. Then we can
have endless discussions on performance.

The SLUB work is still not complete since the intended final fast path
requires new per cpu operations that get thrown one curvball after
another.


