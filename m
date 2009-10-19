Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZJSHK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZJSHK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbZJSHK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:10:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60089 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbZJSHK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:10:57 -0400
Date: Mon, 19 Oct 2009 09:10:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [re-send PATCH] nfs: Fix nfs_parse_mount_options() double
	kfree()
Message-ID: <20091019071051.GA17012@elte.hu>
References: <86802c440910171825j22556a4bofbf0bd6cd134d53c@mail.gmail.com> <84144f020910181935q4aed9f0dx7a8a149d8b8743c7@mail.gmail.com> <20091019114339.4b67d947@infradead.org> <1255921080.839.2.camel@penberg-laptop> <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com> <1255933848.11116.2.camel@heimdal.trondhjem.org> <20091019065433.GA29550@elte.hu> <20091019070421.GA7256@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019070421.GA7256@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


btw., the subject of this patch should probably be changed to:

  nfs: Fix memory leak in nfs_parse_mount_options()

As half of the original fix went upstream via d508afb4 already.

	Ingo
