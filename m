Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYDGVhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYDGVhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYDGVhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:37:35 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46650 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbYDGVhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:37:34 -0400
Message-ID: <47FA93C0.7080807@cs.helsinki.fi>
Date: Tue, 08 Apr 2008 00:36:00 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>  <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com>  <Pine.LNX.4.64.0804072000410.18591@blonde.site> <1207598115.29991.23.camel@lappy> <Pine.LNX.4.64.0804072121320.28744@blonde.site> <47FA8B5A.5090104@cs.helsinki.fi> <47FA8CB0.6070106@cs.helsinki.fi> <Pine.LNX.4.64.0804072215300.2442@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0804072215300.2442@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> I've the uncomfortable feeling that I'm making a big fuss over this
> behaviour on the one hand, but utterly failing to justify that fuss
> on the other.  It seems to come down to me wanting fewer backtraces
> in my logs: I'd better find stronger reasons than that if we're to
> pursue this.

No, I do agree that it's a problem. I just don't like the proposed 
no-merge fix ;-).

		Pekka
