Return-Path: <linux-kernel-owner+w=401wt.eu-S933668AbXIBGrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668AbXIBGrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 02:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbXIBGr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 02:47:27 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33495 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbXIBGr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 02:47:27 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 2 Sep 2007 02:36:05 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: rae l <crquan@gmail.com>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/ipv4/af_inet.c: use ARRAY_SIZE macro from kernel.h
 instead
In-Reply-To: <91b13c310709012330n5ab23496p86423bdcd4fd08f2@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709020235420.22012@localhost.localdomain>
References: <11887091471748-git-send-email-crquan@gmail.com> 
 <Pine.LNX.4.64.0709020100180.17742@localhost.localdomain>
 <91b13c310709012330n5ab23496p86423bdcd4fd08f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007, rae l wrote:

> On 9/2/07, Robert P. J. Day <rpjday@mindspring.com> wrote:

> > denis:
> >
> > if you're planning on doing this ARRAY_SIZE cleanup fairly
> > rigorously, here's an overview of what you're looking (based on a
> > fairly dumb scanning script that undoubtedly generates some false
> > positives).  of course, the respective subsystem maintainers are
> > welcome to deal with them first, of course.
> >
> > p.s.  and when you submit those patches, it's necessary to submit
> > them to only the appropriate subsystem mailing lists, not to the
> > LKML in general.

> I didn't realize that there's so many places to switch to
> ARRAY_SIZE, so now I wonder is this cleaning work valuable to the
> whole kernel tree? or we can keep the current state and just
> encourage new code to use ARRAY_SIZE?

that is *so* not my call.  i just thought that, if you were about to
embark on this clean-up, you knew what was ahead of you.  if you're
still interested in doing it, my best advice is to do it a subsystem
at a time, and submit the patches just to those subsystems or the
appropriate maintainers, rather than to the whole LKML, in order to
keep the traffic down.

and i'd encourage you to keep working on this.  and if you have any
more general questions, you're better off asking on the kernel
janitors list, not LKML.

http://kerneljanitors.org/

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
