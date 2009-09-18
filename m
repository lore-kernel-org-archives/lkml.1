Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZIRDAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZIRDAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 23:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZIRDAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 23:00:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbZIRDAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 23:00:03 -0400
Date: Thu, 17 Sep 2009 19:59:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>
Subject: Re: aim7 scalability issue on 4 socket machine
Message-Id: <20090917195909.3a00ef83.akpm@linux-foundation.org>
In-Reply-To: <1253239339.2606.40.camel@ymzhang>
References: <1253179879.2606.37.camel@ymzhang>
	<1253180411.8497.1.camel@twins>
	<Pine.LNX.4.64.0909171122180.25864@sister.anvils>
	<1253239339.2606.40.camel@ymzhang>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 10:02:19 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> > > Did you see Lee's patch?:
> > > 
> > >  http://lkml.org/lkml/2009/9/9/290
> > > 
> > > Added Lee and Hugh to CC, retained the below patch for them.
> > 
> > Thanks a lot for the CC, Peter.
> > See my reply to that mail for the slightly corrected version.
> > 
> > Yes, Yanmin and Lee appear to be fixing exactly the same issue.
> > I haven't thought through Yanmin's version for correctness, but
> > it lacks the vm_start check I added to Lee's, and I do prefer
> > Lee's style - hey, nothing personal!
> > 
> > So, Yanmin, please retest with http://lkml.org/lkml/2009/9/13/25
> > and let us know if that works as well for you - thanks.
> I tested Lee's patch and it does fix the issue.

Do we think we should cook up something for -stable?

Either this is a regression or the workload is particularly obscure. 

aim7 is sufficiently non-obscure to make me wonder what's happened here?

