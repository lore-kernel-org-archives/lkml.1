Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYG1P0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYG1P0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYG1P0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:26:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45335 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYG1P0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:26:08 -0400
Date: Mon, 28 Jul 2008 12:25:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.27] V4L/DVB updates
Message-ID: <20080728122518.77cea66e@gaivota>
In-Reply-To: <20080728081813.423ac50c.randy.dunlap@oracle.com>
References: <20080727224104.78b8298d@gaivota>
	<20080727204256.bba5eaf6.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0807280303110.18581@bombadil.infradead.org>
	<20080728081813.423ac50c.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.5; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 08:18:13 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 28 Jul 2008 03:08:27 -0400 (EDT) Mauro Carvalho Chehab wrote:
> 
> > Hi Randy,
> > 
> > > I'd really like to get this patch that I mailed to you 2008-July-21 merged...
> > 
> > Your patch looks OK to me. However, this function were moved to 
> > v4l2-dev.c, by the V4L core changes (the changes broke videodev into two 
> > different files, and did some improvements there).
> > 
> > Do you mind to rebase your patch?
> 
> What tree contains v4l2-dev.c?
> It's not in today's linux-next.  Shouldn't it be, or is it for after 2.6.27?

I've changed my procedures to generate my trees, to avoid needing to rebase all
branches (the idea is to have just for_linus rebased).

Due to that change, only yesterday I fixed the updates for linux-next (also,
I've applied the pending patches only yesterday, including the ones that
touched on V4L core). Probably, that's the reason why linux-next is not
updated. Let's see if tomorrow's version will be ok.

At the meantime, you can use my -git tree:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=summary

Cheers,
Mauro.
