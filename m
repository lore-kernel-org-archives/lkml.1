Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZAJQVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZAJQVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 11:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZAJQVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 11:21:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47151 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZAJQVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 11:21:30 -0500
Date: Sat, 10 Jan 2009 17:19:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Scott James Remnant <scott@canonical.com>
Cc: Casey Dahlin <cdahlin@redhat.com>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090110161911.GB10954@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107205322.5F8C7FC3E0@magilla.sf.frob.com> <a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com> <20090108143220.GA8717@redhat.com> <20090108193530.99D74FC3DD@magilla.sf.frob.com> <496663B6.3090709@redhat.com> <20090108213901.GA26729@redhat.com> <1231599141.11642.58.camel@quest>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231599141.11642.58.camel@quest>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Scott James Remnant wrote:
>
> On Thu, 2009-01-08 at 22:39 +0100, Oleg Nesterov wrote:
>
> > Btw. It is not that I am trying to argue against sys_waitfd(), but do
> > you have the "real life" example when it can be useful? Yes, poll().
> > But we have signalfd. SIGCHLD is not rt signal, but afaics this is not
> > the problem actually. Just curious.
> >
> signalfd() can't currently be made to work in the way you describe.

Hmm. Could you clarify?

I am not sure we are talking about the same thing, but afaics poll() +
signalfd can work to (say) reap the childs. Actually, ppoll() alone is
enough.

No?

Oleg.

