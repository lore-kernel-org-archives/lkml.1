Return-Path: <linux-kernel-owner+w=401wt.eu-S934157AbYEFXLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbYEFXLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934028AbYEFXK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:10:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:27511 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbYEFXKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=epiObSTzOe3VFKU1CmT7q5FxmEsDh6r9pzwoV+Sup6yN4Pk1gLEgj7ITNxHlpaOBm6Uotjk9DZ8Y1aO/ZZCptCJcOcRNVBNntSPo+OWimh3g0sk0XtCk7Ml+tjd+eKBxBs1ZEACY2AzSvzwP7TRdXmgThEqsCblWwW11tv0vaJQ=
Message-ID: <cfd18e0f0805061610i48146b3fra3ac378643d51c9e@mail.gmail.com>
Date: Wed, 7 May 2008 01:10:53 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [PATCH 08/18] flag parameters: epoll_create
Cc: "Matthew Helsley" <matthltc@us.ibm.com>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       mtk.manpages@gmail.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805061540560.25162@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805050342.m453gk49029835@devserv.devel.redhat.com>
	 <1210107990.7323.347.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0805061540560.25162@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 12:41 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
>
> On Tue, 6 May 2008, Matthew Helsley wrote:
>
> >
> > On Sun, 2008-05-04 at 23:42 -0400, Ulrich Drepper wrote:
> > > This patch adds the new epoll_create2 syscall.  It extends the old epoll_create
> > > syscall by one parameter which is meant to hold a flag value.  In this
> > > patch the only flag support is EPOLL_CLOEXEC which causes the close-on-exec
> > > flag for the returned file descriptor to be set.
> >
> > Davide, Ulrich,
> >
> >       A minor question: Why did you choose to pass the seemingly useless
> > "size" parameter into the new epoll_create2 system call? I did some
> > googling for previous threads with this series and couldn't find a
> > discussion on why you chose to keep it.
>
> The very first implementations were using an hash, and that was a size
> hint.

So, why not simply remove this argument in the new API, since it is now useless?
