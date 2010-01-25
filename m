Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630Ab0AYWVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0AYWVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746Ab0AYWVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:21:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:38392 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0AYWVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:21:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JqnYN59SGi+gpsHoNuaQrVL5TbH6TasDG+jFLcQI6ki6dVPT163XvEqSqeNL2Fntfs
         RB28s1ONZ20A6meCQgiR4QUFiHVDuLosi7PDhdZBLxSs/Y7BTghUB2GZvbEcUMsr0jJ4
         HvhKeJZbWv2ez+X8LEN1mD4RS37GHwhZFiKEQ=
Date: Mon, 25 Jan 2010 23:21:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
	notifier chain in hw_breakpoint_handler
Message-ID: <20100125222139.GF5087@nowhere>
References: <20091226175533.149765731@linux.vnet.ibm.com> <20091226182833.GC9494@in.ibm.com> <20091231003808.GC23808@nowhere> <20091231190217.GC3676@in.ibm.com> <20100110031857.GB15195@nowhere> <4B4B78D1.2080606@siemens.com> <20100116194058.GA31079@in.ibm.com> <20100120060159.GA4859@in.ibm.com> <4B596C8E.2020600@siemens.com> <20100122092127.GB7127@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100122092127.GB7127@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 02:51:27PM +0530, K.Prasad wrote:
> > >> Such a behaviour shouldn't be affected by the above change...your
> > >> confirmation would help!
> > >>
> > > 
> > > Hi Jan,
> > > 	I presume that the above explanation makes the role of this
> > > patch/bugfix clear.
> > > 
> > > Kindly let me know if you have any further queries.
> > > 
> > 
> > Nope. There should be really no conflicts of your optimization with kvm.
> > 
> > Jan
> > 
> > -- 
> 
> Hi Jan,
> 	Thanks for the confirmation.
> 
> Hi Frederic,
> 	Can you pull these fixes in? (LKML references:
> 20091226182725.GB9494@in.ibm.com and 20091226182833.GC9494@in.ibm.com).


I got a deeper look at these patches and answered with some comments.

If you address these, I can apply for .34 (because it's about optimizations
and not fixes).

Thanks.

