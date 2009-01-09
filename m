Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbZAIVwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbZAIVwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZAIVwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:52:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:45093 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbZAIVwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:52:08 -0500
Date: Fri, 9 Jan 2009 13:54:11 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: Partially defer some of the async stuff to the next release
Message-ID: <20090109135411.53b2dbea@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0901091241470.6528@localhost.localdomain>
References: <20090109070910.233e5f3c@infradead.org>
	<alpine.LFD.2.00.0901091241470.6528@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 12:42:34 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 9 Jan 2009, Arjan van de Ven wrote:
> > 
> > I think it's better that we defer some of the asynchronous boot
> > stuff to 2.6.30 so that it can bake in -next for a bit. I would
> > like to keep the core infrastructure in place for 29, so that the
> > various subsystem patches etc can just use it in -next without
> > generating dependencies in the patch flow.
> > 
> > for both libata and the inode delete very simple things can be done
> > to fix them, but I would feel a lot more comfortable giving these a
> > ride in -next.
> 
> Can we rather make this something that people can enable with a
> "fastboot" option and is disabled by default? At least that way the
> ATA people can see the problem, and don't just forget about it, since
> we want it fixed.


if you pull this you get the patch that removes the inode part for now,
and adds a "fastboot" kernel commandline option to enable the async
behavior.


The following changes since commit
7c51d57e9d7fbce89f79c41dc8da383101dbe9c6: Linus Torvalds (1):
        Merge git://git.infradead.org/mtd-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-async-2
  master

Arjan van de Ven (2):
      partial revert of asynchronous inode delete
      async: make async a command line option for now

 fs/inode.c     |   19 +++++++------------
 kernel/async.c |   16 ++++++++++++++--
 2 files changed, 21 insertions(+), 14 deletions(-)




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
