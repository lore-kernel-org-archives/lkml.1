Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbZAJSYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbZAJSYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZAJSYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:24:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45750 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbZAJSYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:24:10 -0500
Date: Sat, 10 Jan 2009 19:21:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Scott James Remnant <scott@canonical.com>
Cc: Casey Dahlin <cdahlin@redhat.com>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090110182155.GA17516@redhat.com>
References: <20090107123457.GB16268@elte.hu> <20090107205322.5F8C7FC3E0@magilla.sf.frob.com> <a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com> <20090108143220.GA8717@redhat.com> <20090108193530.99D74FC3DD@magilla.sf.frob.com> <496663B6.3090709@redhat.com> <20090108213901.GA26729@redhat.com> <1231599141.11642.58.camel@quest> <20090110161911.GB10954@redhat.com> <1231607398.11642.104.camel@quest>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231607398.11642.104.camel@quest>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Scott James Remnant wrote:
>
> On Sat, 2009-01-10 at 17:19 +0100, Oleg Nesterov wrote:
>
> > I am not sure we are talking about the same thing, but afaics poll() +
> > signalfd can work to (say) reap the childs. Actually, ppoll() alone is
> > enough.
> >
> Last time I checked, ppoll() was not actually implemented across all
> architectures in a manner that solved the race it was intended to solve.
>

As I said, this is imho unfair. But I mentioned ppol() "just in case".

My questiong was why do you think that "signalfd() can't currently be
made to work in the way you describe". You have dropped this part to
change the topic?

Oleg.

