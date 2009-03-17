Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbZCQXIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbZCQXIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZCQXHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:07:47 -0400
Received: from silene.metacarta.com ([208.80.142.18]:33759 "EHLO
	silene.metacarta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZCQXHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:07:46 -0400
Date: Tue, 17 Mar 2009 19:07:42 -0400 (EDT)
From: Joe Malicki <jmalicki@metacarta.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: chrisw@sous-sol.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Message-ID: <9353728.11137281237331262320.JavaMail.root@ouachita>
In-Reply-To: <14026175.11106541237315189656.JavaMail.root@ouachita>
Subject: Re: [PATCH] CRED: Fix check_unsafe_exec()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.80.142.151]
X-Mailer: Zimbra 5.0.9_GA_2533.UBUNTU6 (ZimbraWebClient - [unknown] (Linux)/5.0.9_GA_2533.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Joe Malicki" <jmalicki@metacarta.com> wrote:

> ----- "Hugh Dickins" <hugh@veritas.com> wrote:
> 
> > On Thu, 12 Mar 2009, David Howells wrote:
> > > Hugh Dickins <hugh@veritas.com> wrote:
> > >
> > > > We do.  See the original thread.  It's here at
> > > > http://lkml.org/lkml/2009/2/26/233
> > > > and appended below for convenience.  We do know that patch did
> > not
> > > > fix Joe's problem, and we don't yet know whether addressing the
> > > > files->count issue will actually fix it, but I'm hopeful.
> > >
> > > Looks reasonable.
> >
> > Thanks for taking a look.
> >
> > Yes, I'm inclined to go with that, and removing the files->count
> > check from exec.c.  Joe, did you manage to try your testing with
> > my original patch plus that files->count check removed from 2.6.28's
> > unsafe_exec()?
> 
> Sorry for not responding earlier.
> 
> I still got one failure with this new patch.  I added some printks
> to illuminate exactly why it's failing when it fails to setuid, but
> of course, since adding the printks I haven't reproduced yet.
>

My tests were accidentally run without removing the files->count check.

The printks confirmed the failure case was the files->count check,
and removing the files->check has worked thus far (though I can't be
sure until after a day or two has gone by given how infrequent it is).

Thanks!
Joe
