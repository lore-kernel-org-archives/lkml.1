Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbXGPSgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbXGPSgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbXGPSfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:35:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36802 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbXGPSfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:35:54 -0400
Date: Mon, 16 Jul 2007 11:35:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>
Subject: Re: sysctl.c: add text telling people to use CTL_UNNUMBERED
Message-Id: <20070716113547.5a746fcc.akpm@linux-foundation.org>
In-Reply-To: <20070716112305.6308686f.randy.dunlap@oracle.com>
References: <200707161802.l6GI2h6J006803@hera.kernel.org>
	<20070716112305.6308686f.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 11:23:05 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > +/*
> > + * NOTE: do not add new entries to this table unless you have read
> > + * Documentation/sysctl/ctl_unnumbered.txt
> > + */
> > +/*
> > + * NOTE: do not add new entries to this table unless you have read
> > + * Documentation/sysctl/ctl_unnumbered.txt
> > + */
> >  	{ .ctl_name = 0 }
> >  };
> 
> Are these comments above &  below doubled up for Emphasis??

hm, that could have been some late-night reject-fixing.

sysctl.c is (hopefully "was") the second worst source of rejects in the
tree.

PITA #1 is Documentation/feature-removal-schedule.txt, but that is
fortunately amenable to the insert-it-at-a-random-position solution.

