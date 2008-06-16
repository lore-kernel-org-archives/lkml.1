Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYFPTp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYFPTp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYFPTpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:45:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:39749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbYFPTpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:45:09 -0400
Date: Mon, 16 Jun 2008 12:40:10 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: hidave.darkstar@gmail.com, arjan@linux.intel.com, tytso@mit.edu,
       zwane@arm.linux.org.uk, torvalds@linux-foundation.org,
       marcel@holtmann.org, gregkh@suse.de, jmforbes@linuxtx.org,
       linux-kernel@vger.kernel.org, reviews@ml.cw.f00f.org, cavokz@gmail.com,
       chrisw@sous-sol.org, rdunlap@xenotime.net, w@1wt.eu,
       mkrufky@linuxtv.org, cebbert@redhat.com, davej@redhat.com,
       akpm@linux-foundation.org, chuckw@quantumlinux.com, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 16/47] bluetooth: fix locking bug in the
	rfcomm socket cleanup handling
Message-ID: <20080616194010.GB3804@kroah.com>
References: <20080614000840.GA24659@suse.de> <20080614001058.GP24698@suse.de> <a8e1da0806131950i4eb0ea48q5cc34ea07cfd523a@mail.gmail.com> <20080613.204628.137971521.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613.204628.137971521.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 08:46:28PM -0700, David Miller wrote:
> From: "Dave Young" <hidave.darkstar@gmail.com>
> Date: Sat, 14 Jun 2008 10:50:51 +0800
> 
> > On Sat, Jun 14, 2008 at 8:10 AM, Greg KH <gregkh@suse.de> wrote:
> > > -stable review patch.  If anyone has any objections, please let us know.
> > >
> > > ------------------
> > > From: Arjan van de Ven <arjan@linux.intel.com>
> > >
> > > [ Upstream commit: 7dccf1f4e1696c79bff064c3770867cc53cbc71c ]
> > 
> > Hi greg
> > Please including following commit as well because it will cause another bug:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=537d59af73d894750cff14f90fe2b6d77fbab15b
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks, I'll go add it to the tree for this release.

greg k-h
