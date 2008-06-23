Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYFWV7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYFWV7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYFWV7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:59:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:39609 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbYFWV7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:59:08 -0400
Date: Mon, 23 Jun 2008 14:43:59 -0700
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jmforbes@linuxtx.org,
       zwane@arm.linux.org.uk, tytso@mit.edu, rdunlap@xenotime.net,
       davej@redhat.com, chuckw@quantumlinux.com, reviews@ml.cw.f00f.org,
       mkrufky@linuxtv.org, cebbert@redhat.com, cavokz@gmail.com, w@1wt.eu,
       rbranco@la.checkpoint.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 3/5] sctp: Make sure N * sizeof(union sctp_addr) does
	not overflow.
Message-ID: <20080623214359.GA16851@suse.de>
References: <20080622190136.GC20141@suse.de> <20080622.122332.220246399.davem@davemloft.net> <20080622202847.GA20800@suse.de> <20080623.143621.195102953.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623.143621.195102953.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 02:36:21PM -0700, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Sun, 22 Jun 2008 13:28:47 -0700
> 
> > On Sun, Jun 22, 2008 at 12:23:32PM -0700, David Miller wrote:
> > > From: Greg KH <gregkh@suse.de>
> > > Date: Sun, 22 Jun 2008 12:01:36 -0700
> > > 
> > > > 2.6.25-stable review patch.  If anyone has any objections, please let us
> > > > know.
> > > 
> > > Unfortunately, Vlad found another case in SCTP which has
> > > an overflow bug similar to this one.  I'll work on a
> > > fix for that today and submit.
> > 
> > Thanks for letting me know, I'll wait for that one as well before doing
> > this release.
> 
> This one turned out to be a false alarm, and Vlad confirmed my
> analysis today.  So there is no other SCTP patch you need to
> wait for.

Great, thanks for letting me know.

greg k-h
