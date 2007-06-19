Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbXFSBQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbXFSBQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 21:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbXFSBQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 21:16:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:33037 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242AbXFSBQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 21:16:13 -0400
Subject: Re: [RFC] [PATCH] selective signal ptracing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Roland McGrath <roland@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       john.blackwood@ccur.com, linux-kernel@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>, bugsy@ccur.com
In-Reply-To: <625fc13d0706180615t2f327b16rf648b2ee56da6ed9@mail.gmail.com>
References: <1182039062.26853.111.camel@localhost.localdomain>
	 <20070617012952.09F2D4D059F@magilla.localdomain>
	 <625fc13d0706180615t2f327b16rf648b2ee56da6ed9@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 11:15:00 +1000
Message-Id: <1182215700.26853.299.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 08:15 -0500, Josh Boyer wrote:
> On 6/16/07, Roland McGrath <roland@redhat.com> wrote:
> > > What are the issues with arch like ARM ?
> >
> > The interesting class ARM belongs to is machines that don't (or don't
> > always) have hardware support for single-step.  Maintaining the status quo
> > of how PTRACE_SINGLESTEP functions on these machines is different in
> > implementation under utrace than it is for machines that always use
> > hardware support.  That is the only special complication for ARM, and it is
> > not really very complicated.  Apparently the way I described the issue in
> > the past was easily misunderstood.
> 
> That isn't just ARM.  There are some embedded PowerPC chips that lack
> an easily usable hardware single step.  Just an FYI.

Note that we could use xmon infrastructure for that ... Paul has the
whole shebang done in there, including emulating branches etc...

Ben.


