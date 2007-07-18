Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbXGRWig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbXGRWig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760643AbXGRWi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:38:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760718AbXGRWiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:38:25 -0400
Date: Thu, 19 Jul 2007 00:38:20 +0200
From: Karel Zak <kzak@redhat.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] Delete export of tty.h to userspace.
Message-ID: <20070718223820.GF3181@petra.dvoda.cz>
References: <Pine.LNX.4.64.0707180520040.19434@localhost.localdomain> <469E7599.4060608@gmail.com> <Pine.LNX.4.64.0707181631340.14452@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707181631340.14452@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 04:33:12PM -0400, Robert P. J. Day wrote:
> On Wed, 18 Jul 2007, Jiri Slaby wrote:
> 
> > Robert P. J. Day napsal(a):
> > >   given that the entire contents of include/linux/tty.h is contained
> > > within an "#ifdef __KERNEL__", it seems pointless to export it to
> > > userspace, unless there's some kind of need for that header file to
> > > exist in userspace, even if it's empty.
> > >
> > >   a quick grep shows that nothing under /usr/include references any
> > > file of the name "tty.h" in any way.  thoughts?
> >
> > If we decide to remove the file, I would rather go through
> > deprecation of the file with filing an entry in
> > feature-remove-schedule. There still seems to be some users of the
> > file.
> 
> i'm curious -- how did you determine that?

 $ grep "tty.h" util-linux/sys-utils/cytune.c
 #include <linux/tty.h>

 ... I'll fix it in util-linux-ng.


    Karel

-- 
 Karel Zak  <kzak@redhat.com>
