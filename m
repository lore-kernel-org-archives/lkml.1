Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbXEPFPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbXEPFPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXEPFPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:15:25 -0400
Received: from mx12.go2.pl ([193.17.41.142]:48175 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754665AbXEPFPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:15:25 -0400
Date: Wed, 16 May 2007 07:21:59 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070516052159.GA967@ff.dom.local>
References: <20070511134714.GA191@tv-sign.ru> <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com> <20070514194446.GA159@tv-sign.ru> <46496EC1.3090109@gmail.com> <20070515130904.GB3050@ff.dom.local> <20070515220812.GB615@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515220812.GB615@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 02:08:12AM +0400, Oleg Nesterov wrote:
> On 05/15, Jarek Poplawski wrote:
> > 
> > I've overheared somebody is talking about my favorite 2-nd bit!
...
> We already discussed this... Surely, we can do this. I believe
> this will complicate (and _imho_ uglify) the code too much.

Yes, but now I see you are about to change your mind about
this bit...

> May be I am wrong. Please provide a detailed description?

I'll try too look more at your solution - maybe it's "not
so bad". I've probably exaggerated yesterday about this
overhead of setting the VALID bit.

Cheers,
Jarek P.
