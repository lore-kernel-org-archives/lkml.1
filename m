Return-Path: <linux-kernel-owner+w=401wt.eu-S1765666AbZDCNI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765666AbZDCNI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765554AbZDCNHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:07:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35716 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765571AbZDCNHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:07:49 -0400
Date: Fri, 3 Apr 2009 15:07:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Talpey <tmtalpey@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Yinghai Lu <yinghai@kernel.org>,
       David Miller <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>, chuck.lever@oracle.com
Subject: Re: [PATCH] nfs: fix nfs_parse_mount_options() double kfree()
Message-ID: <20090403130724.GA26365@elte.hu>
References: <86802c440904021512o2405ffa2gcbe057b9f81d5a46@mail.gmail.com> <20090402222106.GC9239@elte.hu> <49D56415.1080402@kernel.org> <84144f020904022252v2dbc18f5o35cc9737bf6d146d@mail.gmail.com> <20090403071638.GB14498@elte.hu> <49d5fe00.86c3f10a.0641.ffffbbdd@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49d5fe00.86c3f10a.0641.ffffbbdd@mx.google.com>
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


* Tom Talpey <tmtalpey@gmail.com> wrote:

> At 03:16 AM 4/3/2009, Ingo Molnar wrote:
> >
> >Impact: fix crash
> >
> >Yinghai Lu reported the following crash:
> 
> This has to have been a merge problem, I moved a single kfree() 
> down a few lines in order to use the pointer in a second context. 
> With the moved line, it had been running successfully in Trond's 
> tree and linux-next for several weeks.

Maybe the tree got rebased and that introduced this merge artifact? 

> Thanks for fixing!

You are welcome!

	Ingo
