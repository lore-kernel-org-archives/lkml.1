Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbZEDNOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbZEDNOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 09:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZEDNOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 09:14:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57085 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbZEDNOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 09:14:14 -0400
Date: Mon, 4 May 2009 15:13:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
Message-ID: <20090504131311.GA23330@elte.hu>
References: <20090504122740.GH4173@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504122740.GH4173@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Hi,
> 
> here is an attempt to bring in __GFP_PANIC modifier.
> The patch is made on top of -tip repo. I've been
> trying to apply it in top of -mm tree but it
> seems -tip is a bit newer, at least it already
> has __GFP_BITS_SHIFT = 22 defined.

Please create a patch against -mm instead. The one in -tip is bumped 
up by:

  8cd4001: kmemcheck: add hooks for the page allocator
  e6df103: kmemcheck: add mm functions

But we dont want to mix that into your patch.

Thanks,

	Ingo
