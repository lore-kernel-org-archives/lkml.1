Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYCXPwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYCXPwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbYCXPwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:52:19 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:42264 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751808AbYCXPwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:52:18 -0400
X-Trace: 691395613/mk-filter-2.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUHAFhq50dRAVlC/2dsb2JhbACBW6VY
Subject: Re: [PATCH] 3/3 maple: update bus driver to support Dreamcast VMU
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <20080324152952.GF2899@logfs.org>
References: <1206207805.6324.13.camel@localhost.localdomain>
	 <1206209786.6324.41.camel@localhost.localdomain>
	 <20080324033344.GB15872@linux-sh.org> <20080324144647.GC2899@logfs.org>
	 <1206371178.6283.37.camel@localhost.localdomain>
	 <20080324152952.GF2899@logfs.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 24 Mar 2008 15:51:40 +0000
Message-Id: <1206373900.6283.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-24 at 16:29 +0100, Jörn Engel wrote:
> On Mon, 24 March 2008 15:06:18 +0000, Adrian McMenamin wrote:
> > 
> > I don't think I have any alternative here. The problem is that the bus
> > checks periodically (every HZ ticks but that could be changed) if a
> > device remains connected to the system by queueing a status command. (If
> > the status command is replied to with a "No response" then that
> > indicates to the bus that the device has been removed.
> 
> Where does this queueing happen?  Somewhere in the kernel where we can
> control it or in hardware?

Well, the queuing of the status command is under software control.

