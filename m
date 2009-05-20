Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZETOAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZETOAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbZETOAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:00:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43880 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbZETOAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:00:34 -0400
Date: Wed, 20 May 2009 15:55:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: INFO: possible circular locking dependency at
	cleanup_workqueue_thread
Message-ID: <20090520135537.GA18480@redhat.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com> <20090517071834.GA8507@elte.hu> <1242821938.26820.586.camel@twins> <20090520131823.GA14933@redhat.com> <1242827092.26820.612.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242827092.26820.612.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, Peter Zijlstra wrote:
>
> On Wed, 2009-05-20 at 15:18 +0200, Oleg Nesterov wrote:
> > On 05/20, Peter Zijlstra wrote:
> > >
> > > Breaking the setup_lock -> cpu_add_remove_lock dependency seems
> > > sufficient.
> >
> > Hmm. What do you mean? Afaics setup_lock -> cpu_add_remove_lock
> > is not a problem?
>
> >From what I could see that is the only dependency that makes
> cpu_add_remove_lock nest under "events" workqueue 'lock', which is what
> is generating the deadlock.

But cpu_add_remove_lock does not participate in this deadlock, see
http://marc.info/?l=linux-kernel&m=124274977707363 ?

Perhaps you mean something else, could you spell in that case?

Oleg.

