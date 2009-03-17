Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbZCQJEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbZCQJEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 05:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbZCQJEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 05:04:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58340 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293AbZCQJEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 05:04:41 -0400
Date: Tue, 17 Mar 2009 10:04:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH next] slob: fix build problem
Message-ID: <20090317090433.GE16952@elte.hu>
References: <20090317082549.GA5127@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317082549.GA5127@orion>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Beregalov <a.beregalov@gmail.com> wrote:

> mm/slob.c: In function '__kmalloc_node':
> mm/slob.c:480: error: 'flags' undeclared (first use in this function)
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

thanks, fixed it two days ago:

  bf722c9: lockdep: annotate reclaim context (__GFP_NOFS), fix SLOB

also posted on lkml.

	Ingo
