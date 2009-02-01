Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZBABtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZBABtT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 20:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZBABtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 20:49:08 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:50034 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZBABtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 20:49:06 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 31 Jan 2009 17:49:05 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: mtk.manpages@gmail.com
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>,
       Bron Gondwana <brong@fastmail.fm>
Subject: Re: [patch] drop epoll max_user_instances and rely only on 
 max_user_watches
In-Reply-To: <cfd18e0f0901311743o48e192eftfbc37bf8136fe54@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901311748350.18888@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901282010250.21401@alien.or.mcafeemobile.com>  <20090129005716.6dd51929.akpm@linux-foundation.org>  <cfd18e0f0901290203r139cb5bfgc02a0dcb1347aba8@mail.gmail.com>  <alpine.DEB.1.10.0901291053580.15448@alien.or.mcafeemobile.com>
  <cfd18e0f0901311726n439d3034qa87f3ab31acd4858@mail.gmail.com>  <alpine.DEB.1.10.0901311728220.18888@alien.or.mcafeemobile.com> <cfd18e0f0901311743o48e192eftfbc37bf8136fe54@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Feb 2009, Michael Kerrisk wrote:

> Hi Davide,
> 
> On Sun, Feb 1, 2009 at 2:30 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > On Sun, 1 Feb 2009, Michael Kerrisk wrote:
> >
> >> Hi Davide,
> >>
> >> On Fri, Jan 30, 2009 at 7:54 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> >> > On Thu, 29 Jan 2009, Michael Kerrisk wrote:
> >> >
> >> >> Since max_user_instances was added in 2.6.28, and this is an ABI
> >> >> change, I suggest this should go into .29-rc, so that
> >> >> max_user_instances spends as little time in the wild as possible.
> >> >
> >> > Agreed, like I already told Andrew. Sorry Michael for the double change to
> >> > the man page :/
> >>
> >> So is the right change to the epoll(7) page (see
> >> http://www.kernel.org/doc/man-pages/online/pages/man7/epoll.7.html )
> >> to simply remive the text on max_user_instances:
> >>
> >>        /proc/sys/fs/epoll/max_user_instances (since Linux 2.6.28)
> >>               This  specifies  an  upper  limit on the number of epoll
> >>               instances that can be created per real user ID.
> >>
> >> Or are other changes also required?
> >
> > Yes. Plus, max_user_watches, instead of being 1/32 of lowmem, it's 4%.
> > Just a detail.
> 
> Would you please review the following patch, which comments out the
> text for max_user_instances, and updates the numbers for
> max_user-watches.

Thank you Michael, looks fine to me.


- Davide


