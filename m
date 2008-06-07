Return-Path: <linux-kernel-owner+w=401wt.eu-S1760105AbYFGCBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbYFGCBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 22:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYFGCBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 22:01:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54908 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYFGCBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 22:01:19 -0400
Date: Fri, 6 Jun 2008 18:57:30 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Tejun Heo <htejun@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, matthieu.castet@parrot.com,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 10/50] libata: force hardreset if link is in
	powersave mode
Message-ID: <20080607015730.GA15123@kroah.com>
References: <20080607010215.358296706@sous-sol.org> <20080607010555.470605116@sous-sol.org> <alpine.LFD.1.10.0806061826420.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806061826420.3473@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 06:27:15PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 6 Jun 2008, Chris Wright wrote:
> >
> > -stable review patch.  If anyone has any objections, please let us know.
> > ---------------------
> > 
> > From: Tejun Heo <htejun@gmail.com>
> > 
> > Inhibiting link PM mode doesn't bring the link back online if it's
> > already in powersave mode.  If SRST is used in these cases, libata EH
> > thinks that the link is offline and fails detection.  Force hardreset
> > if link is in powersave mode.
> 
> This isn't upstream. Maybe there's some reason it's not needed upstream, 
> but it would be nice to know.

To quote Tejun when he sent this patch:
	---
	Patch for -stable only.  Devel branch now uses hardreset by
	default so this type of promotion logic isn't necessary anymore.


thanks,

greg k-h
