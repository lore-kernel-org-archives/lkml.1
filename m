Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYIWIhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYIWIhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 04:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYIWIhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 04:37:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54867 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbYIWIhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 04:37:02 -0400
Date: Tue, 23 Sep 2008 10:36:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/2] corruption check: move the corruption checks into
	their own file
Message-ID: <20080923083643.GF23031@elte.hu>
References: <20080922195810.624d777a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922195810.624d777a@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> updated patch based on feedback from Randy that I should fix 
> whitespace issues while moving code

but that's wrong. You should _never_ change code while moving it because 
it's utterly unreviewable. Please split into two patches: first move the 
code, then do the style cleanups in the target file.

also, could you please rename the new file to check.c - it's shorter and 
we might check other things there too.

	Ingo
