Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbZC3HLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbZC3HLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZC3HLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:11:35 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44975 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZC3HLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:11:35 -0400
Subject: Re: [patch 1/3] slub: add per-cache slab thrash ratio
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com>
Date: Mon, 30 Mar 2009 10:11:31 +0300
Message-Id: <1238397091.26742.35.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-29 at 22:43 -0700, David Rientjes wrote:
> The slab_thrash_ratio for each cache do not have non-zero defaults
> (yet?).

If we're going to merge this code, I think it would be better to put a
non-zero default there; otherwise we won't be able to hit potential
performance regressions or bugs. Furthermore, the optimization is not
very useful on large scale if people need to enable it themselves.

Maybe stick 20 there and run tbench, sysbench, et al to see if it makes
a difference? I'm cc'ing Mel in case he has some suggestions how to test
it.

			Pekka

