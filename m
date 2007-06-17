Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbXFQBaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbXFQBaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 21:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbXFQB3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 21:29:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430AbXFQB3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 21:29:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Fcc: ~/Mail/utrace
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, john.blackwood@ccur.com,
       linux-kernel@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>, bugsy@ccur.com
Subject: Re: [RFC] [PATCH] selective signal ptracing
In-Reply-To: Benjamin Herrenschmidt's message of  Sunday, 17 June 2007 10:11:02 +1000 <1182039062.26853.111.camel@localhost.localdomain>
Emacs: because one operating system isn't enough.
Message-Id: <20070617012952.09F2D4D059F@magilla.localdomain>
Date: Sat, 16 Jun 2007 18:29:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What are the issues with arch like ARM ? 

The interesting class ARM belongs to is machines that don't (or don't
always) have hardware support for single-step.  Maintaining the status quo
of how PTRACE_SINGLESTEP functions on these machines is different in
implementation under utrace than it is for machines that always use
hardware support.  That is the only special complication for ARM, and it is
not really very complicated.  Apparently the way I described the issue in
the past was easily misunderstood.

> Also, is there a mail thread or paper somewhere describing utrace, its
> interfaces and what's needed to hook it up on a platform ?

See http://redhat.com/~roland/utrace/ for the patches and a porting howto.
The patches add a Documentation/ file and kerneldoc stuff for the interfaces.


Thanks,
Roland
