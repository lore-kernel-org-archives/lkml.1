Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbXKWTPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbXKWTPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 14:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXKWTO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 14:14:56 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:15274 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbXKWTOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 14:14:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VPEO8TIDCpPO6mNsqLoCKqNyAsfqj5wT+7iwmccRkcqHAv1CAoBEz6rpaLnUd73U9QsecrQouRLtcWzu5dyp7e7lo3G1EZRvP2xoyDaCnRN190crlwjUbY0cLLItwswU47fpGEbRusbuNq3qT1BS8q1xCqQnrS9w70mDIvFBkIs=
Message-ID: <cfd18e0f0711231114l33f3c4b8t9a6dbadaf0e9b0a3@mail.gmail.com>
Date: Fri, 23 Nov 2007 20:14:54 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Ulrich Drepper" <drepper@gmail.com>
Subject: Re: Where is the new timerfd?
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <a36005b50711231038j48325a41o26d1749ee89ab64d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0711220324l533d9048yf05c399019764b62@mail.gmail.com>
	 <cfd18e0f0711221048k538d05abk8e4303d5f90a6e1b@mail.gmail.com>
	 <Pine.LNX.4.64.0711221145410.7431@alien.or.mcafeemobile.com>
	 <20071122162430.48f55995.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0711221634510.7431@alien.or.mcafeemobile.com>
	 <20071122173437.e74890a8.akpm@linux-foundation.org>
	 <cfd18e0f0711230439m1d72abdle4d5050b0bd935a1@mail.gmail.com>
	 <20071123091254.45f4193d.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0711230928590.15603@alien.or.mcafeemobile.com>
	 <a36005b50711231038j48325a41o26d1749ee89ab64d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 23, 2007 7:38 PM, Ulrich Drepper <drepper@gmail.com> wrote:
> On Nov 23, 2007 9:29 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > Yes, it's disabled, and yes, I'll repost today ...
>
> I haven't seen the patch and don't feel like searching.  So I say it
> here: please mak sure you add a flags parameter to the system call
> itself (instead of adding it on as for eventfd and signalfd).  We need
> to be able to use O_CLOEXEC some way or another.

Seems reasonable to add this for timer_create() (though unfortunate
that it is now too late to do the same for eventfd() and signalfd()).
Davide, what do you think?

Cheers,

Michael
