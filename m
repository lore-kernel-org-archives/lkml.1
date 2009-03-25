Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbZCYKP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbZCYKP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZCYKPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:15:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51865 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbZCYKPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:15:15 -0400
Date: Wed, 25 Mar 2009 11:14:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] blktrace: fix the original blktrace
Message-ID: <20090325101451.GK2341@elte.hu>
References: <49C9F700.9070609@cn.fujitsu.com> <49C9F796.9040503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C9F796.9040503@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Currently the original blktrace, which is using relay and is used 
> via ioctl, is broken. You can use ftrace to see the output of 
> blktrace, but user-space blktrace is unusable.

good catch, thanks Li!

Jens, Arnaldo, do these fixes look good to you too?

	Ingo
