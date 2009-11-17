Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbZKQNLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbZKQNLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 08:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZKQNLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 08:11:38 -0500
Received: from smtp.nokia.com ([192.100.105.134]:49738 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZKQNLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 08:11:37 -0500
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David VomLehn <dvomlehn@cisco.com>, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org, dwm2@infradead.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
In-Reply-To: <2ea1731b0911170445x13225c19w797388d2211de2d9@mail.gmail.com>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
	 <4AFC4D31.2000101@gmail.com>
	 <20091112215649.GA28349@dvomlehn-lnx2.corp.sa.net>
	 <20091113091031.3f6d4bba@marrow.netinsight.se>
	 <1258112748.21596.1227.camel@localhost> <4AFE6A14.4010507@gmail.com>
	 <1258447997.27437.76.camel@localhost>
	 <2ea1731b0911170445x13225c19w797388d2211de2d9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 15:10:04 +0200
Message-Id: <1258463404.27437.103.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Nov 2009 13:10:10.0420 (UTC) FILETIME=[4AA73B40:01CA6787]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 13:45 +0100, Marco Stornelli wrote:
> 2009/11/17 Artem Bityutskiy <dedekind1@gmail.com>:
> > Take a look at my mails where I describe different complications we have
> > in our system. We really want to have an OOPS/panic + our environment
> > stuff to go together, at once. This makes things so much simpler.
> >
> > Really, what is the problem providing this trivial panic-note
> > capability, where user-space can give the kernel a small buffer, and ask
> > the kernel to print this buffer at the oops/panic time. Very simple and
> > elegant, and just solves the problem.
> >
> > Why perversions with time-stamps, separate storages are needed?
> >
> > IOW, you suggest a complicated approach, and demand explaining why we do
> > not go for it. Simply because it is unnecessarily complex.
> 
> I don't think it's a complicated approach we are talking of a system
> log like syslog with a temporal information, nothing more.

We need to store this information of NAND flash. Implementing logs on
NAND flash is about handling bad blocks, choosing format of records, and
may be even handling wear-levelling. This is not that simple.

And then I have match oops to the userspace environment prints, using I
guess timestamps, which is also about complications in userspace.

> > This patch solves the problem gracefully, and I'd rather demand you to point what
> > is the technical problem with the patches.
> >
> 
> Simply because I think that we should avoid to include in the kernel
> things we can do in a simply way at user space level.

If it is much easier to have in the kernel, then this argument does not
work, IMHO.

>  I think this
> patch is well done but it's one of the patches that are solutions "for
> embedded only", but it's only my opinion.

Also IMHO, but having embedded-only things is not bad at all.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

