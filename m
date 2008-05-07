Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbYEGRfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbYEGRfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYEGRey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:34:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54021 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbYEGRex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:34:53 -0400
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <20080507091748.GB30645@elte.hu>
References: <1210039590.3453.18.camel@ymzhang>
	 <20080507091748.GB30645@elte.hu>
Content-Type: text/plain
Date: Wed, 07 May 2008 19:34:17 +0200
Message-Id: <1210181657.6525.7.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-07 at 11:17 +0200, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > Comparing with 2.6.25, volanoMark has big regression with kernel 
> > 2.6.26-rc1. It's about 50% on my 8-core stoakley, 16-core tigerton, 
> > and Itanium Montecito.
> > 
> > With bisect, I located below patch.
> 
> thanks Yanmin, i've queued up your patch that reverts this change.

Is this really needed now that GROUP_SCHED defaults to 'n' ?

Yanmin, this is with GROUP_SCHED=y, right or is this without?

