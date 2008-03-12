Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbYCLVXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbYCLVXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYCLVWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:22:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:50681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYCLVWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:22:52 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
Date: Wed, 12 Mar 2008 22:22:04 +0100
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>, David Newall <davidn@davidnewall.com>,
       Theodore Tso <tytso@mit.edu>, "Fred ." <eldmannen@gmail.com>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <47D8091E.6030906@davidnewall.com> <Pine.LNX.4.64.0803121748140.15209@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0803121748140.15209@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803122222.05663.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX193UNsmH3wo+YUwTgyjvol/nT2XwzBvJaVrwxi
 JEIjsA01FZ4cTiBeIIPOr3GA1fPZWIYHMiqSqejnFSSeIw86wg
 ImAcrzmQdvbRFScwXyUKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 12. März 2008 schrieb Jiri Kosina:
> On Thu, 13 Mar 2008, David Newall wrote:
> > > The problem is that under heavy load the auto-repeat problem is real;
> > > I've seen it as well, and it means that I've started to try to avoid
> > > "make -j4" since that's a great way to trigger it.
> >
> > I'm sure it does suck under heavy load, although I suppose you could
> > increase the start time.  But I wonder if that is the problem this
> > time?  Modern machines are so damned fast they actually take real
> > effort to load.  Actually, "make -j4" doesn't sound particularly heavy.
> > There's huge disk i/o in a make.  Plenty of scheduling opportunities.
> > Obviously I only know what everybody else here knows; but with so many
> > recent posts suggesting a scheduling fault has been introduced, I'm
> > expecting it to be that.
>
> The problem became much more apparent during early -rc phase of 2.6.25
> for those people that have CONFIG_GROUP_SCHED turned on. This clearly
> shows that X are somehow unhappy with how kernel schedules them, but I
> don't have idea how autorepeat is implemented inside X and what could be
> the problem right now.

Just for the record, this problem started with openSUSE 10.2 for me, that's 
a 2.6.18 thingy. I'm a heavy xterm user, where the autorepeat gets a life 
of its own _occasionally_. I'm able to stop it by triggering a autorepeat 
manually (typical antidot reaction).

Pete
