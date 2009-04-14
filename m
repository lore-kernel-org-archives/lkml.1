Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZDNAnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZDNAnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbZDNAm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:42:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZDNAm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:42:58 -0400
Date: Tue, 14 Apr 2009 02:42:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>
Cc: torvalds@osdl.org, roland@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] add ptrace entry to MAINTAINERS
Message-ID: <20090414004231.GA17288@elte.hu>
References: <20090413152010.GA16682@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413152010.GA16682@lst.de>
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


* Christoph Hellwig <hch@lst.de> wrote:

> At the LF collab summit we decided to make Roland official ptrace
> maintainer not just the defacto one he has been for a couple of years
> now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hm, what is this "LF collab summit" that makes decisions in terms of 
who maintains what? Some new buerocracy on top of Linux i have not 
heard about yet? :)

Because you got your facts wrong: the real ptrace de-facto 
maintainer is Oleg Nesterov and Andrew Morton, as per 
kernel/ptrace.c and arch/x86/kernel/ptrace.c signoffs since v2.6.27:

      2  Tejun Heo 
      2  WANG Cong 
      3  Roland McGrath 
      4  David Howells 
      5  James Morris 
      6  Oleg Nesterov 
      7  Andrew Morton 
      9  Linus Torvalds 
      9  Markus Metzger 
     22  Ingo Molnar 

Oleg has been doing most of the heavy lifting in terms of reviewing 
patches, acking patches and most importantly: keeping bad patches 
out of the ptrace code - in the past year or so.

Although i would certainly not mind Roland getting more active in 
this space either :)

But in terms of fairness, if you so conveniently 'decide' who 
maintains ptrace then Oleg is a must-have maintainer in that space 
too.

	Ingo
