Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbZCXIk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbZCXIk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZCXIkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:40:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833AbZCXIkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:40:16 -0400
Date: Tue, 24 Mar 2009 09:39:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] blktrace: print human-readable act_mask
Message-ID: <20090324083956.GC13016@elte.hu>
References: <49C893FC.9080905@cn.fujitsu.com> <49C89488.4030604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C89488.4030604@cn.fujitsu.com>
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

> Print stringified act_mask instead of hex value:
>  # cat act_mask
>  read,write,barrier,sync,queue,requeue,issue,complete,fs,pc,ahead,meta,
>  discard,drv_data
>  # echo "meta,write" > act_mask
>  # cat act_mask
>  write,meta

btw., does user-space blktrace make use of this facility?

	Ingo
