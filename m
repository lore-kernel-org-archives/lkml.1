Return-Path: <linux-kernel-owner+w=401wt.eu-S1761361AbXGZGH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbXGZGH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 02:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbXGZGHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 02:07:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48115 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754569AbXGZGHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 02:07:15 -0400
Date: Wed, 25 Jul 2007 23:06:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ray Lee <ray-lk@madrabbit.org>, Eric St-Laurent <ericstl34@sympatico.ca>,
       Rene Herman <rene.herman@gmail.com>,
       Jesper Juhl <jesper.juhl@gmail.com>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-Id: <20070725230609.d2d1be59.akpm@linux-foundation.org>
In-Reply-To: <46A836E1.1000404@yahoo.com.au>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	<46A57068.3070701@yahoo.com.au>
	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	<46A58B49.3050508@yahoo.com.au>
	<2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	<46A6CC56.6040307@yahoo.com.au>
	<46A6D7D2.4050708@gmail.com>
	<1185341449.7105.53.camel@perkele>
	<46A6E1A1.4010508@yahoo.com.au>
	<2c0942db0707250909r435fef75sa5cbf8b1c766000b@mail.gmail.com>
	<20070725215717.df1d2eea.akpm@linux-foundation.org>
	<46A836E1.1000404@yahoo.com.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 15:53:37 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Not that I want to say anything about swap prefetch getting merged: my
> inbox is already full of enough "helpful suggestions" about that,

give them the kernel interfaces, they can do it themselves ;)

> so I'll
> just be happy to have a look at little things like updatedb.

Yes, that is a little thing.  I mean, even if the kernel's behaviour
during an updatedb run was "perfect" (ie: does what we the designers
curently intend it to do (whatever that is)) then the core problem isn't
solved: short-term workload evicts your working set and you have to
synchronously reestablish it.
