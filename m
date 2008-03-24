Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbYCXQE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbYCXQE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYCXQEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:04:46 -0400
Received: from lazybastard.de ([212.112.238.170]:41867 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbYCXQEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:04:45 -0400
Date: Mon, 24 Mar 2008 17:04:30 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] 3/3 maple: update bus driver to support Dreamcast VMU
Message-ID: <20080324160429.GG2899@logfs.org>
References: <1206207805.6324.13.camel@localhost.localdomain> <1206209786.6324.41.camel@localhost.localdomain> <20080324033344.GB15872@linux-sh.org> <20080324144647.GC2899@logfs.org> <1206371178.6283.37.camel@localhost.localdomain> <20080324152952.GF2899@logfs.org> <1206373900.6283.39.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1206373900.6283.39.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 March 2008 15:51:40 +0000, Adrian McMenamin wrote:
> On Mon, 2008-03-24 at 16:29 +0100, Jörn Engel wrote:
> > On Mon, 24 March 2008 15:06:18 +0000, Adrian McMenamin wrote:
> > > 
> > > I don't think I have any alternative here. The problem is that the bus
> > > checks periodically (every HZ ticks but that could be changed) if a
> > > device remains connected to the system by queueing a status command. (If
> > > the status command is replied to with a "No response" then that
> > > indicates to the bus that the device has been removed.
> > 
> > Where does this queueing happen?  Somewhere in the kernel where we can
> > control it or in hardware?
> 
> Well, the queuing of the status command is under software control.

Then we should be fine.  I'll try to beat the code into submission.

Jörn

-- 
Joern's library part 7:
http://www.usenix.org/publications/library/proceedings/neworl/full_papers/mckusick.a
