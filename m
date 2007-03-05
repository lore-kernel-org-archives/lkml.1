Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbXCETLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbXCETLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 14:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932270AbXCETLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 14:11:14 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37757
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbXCETLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 14:11:13 -0500
From: Michael Buesch <mb@bu3sch.de>
To: David Brownell <david-b@pacbell.net>
Subject: Re: 2.6.21-rc2-mm1: drivers/usb/host/ohci-ssb.c doesn't compile
Date: Mon, 5 Mar 2007 20:09:25 +0100
User-Agent: KMail/1.9.5
Cc: greg@kroah.com, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <200703051226.46402.mb@bu3sch.de> <200703051042.06802.david-b@pacbell.net>
In-Reply-To: <200703051042.06802.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703052009.26136.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 19:42, David Brownell wrote:
> On Monday 05 March 2007 3:26 am, Michael Buesch wrote:
> 
> > > Actually, it seems like I will run into other kinds of nasty problems
> > > due to stupid design of the HCD code. The OHCI code #includes
> > > the various drivers, which have a module_init each. So if you
> > > compile PCI and SSB support, you have two module_init for one
> > > OHCI module. Not sure how to fix this. Any idea?
> > 
> > A real problem is that the HCD core seems to have the assumption
> > built-in that there can only be one OHCI driver per machine/arch.
> 
> What ancient version of the driver are you referring to??

Uh, can't be _that_ ancient, as I wrote this stuff only a few weeks ago. :)

> CURRENT code has one module_init, and can hook up to several
> different kinds of bus glue.  There *is* only one OHCI driver.
> It can hook up through several different kinds of bus glue; a
> few platforms support more than one way to connect to various
> implementations of OHCI.

Yeah, good to see that this changed. I'll fixup the stuff. Thanks.

-- 
Greetings Michael.
