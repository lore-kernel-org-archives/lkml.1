Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbZKBSZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbZKBSZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932134AbZKBSZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:25:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48516 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbZKBSZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:25:39 -0500
Date: Mon, 2 Nov 2009 19:25:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] perf tools: Simplify the symbol priv area mechanism
Message-ID: <20091102182525.GA673@elte.hu>
References: <1256927305-4628-1-git-send-email-acme@infradead.org> <1256927305-4628-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1256927305-4628-2-git-send-email-acme@infradead.org>
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


btw, on 64-bit i'm getting:

util/map.c: In function ‘map__find_symbol’:
util/map.c:97: error: field precision should have type ‘int’, but argument 3 has type ‘size_t’

	Ingo
