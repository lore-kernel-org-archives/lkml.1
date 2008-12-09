Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYLIUlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYLIUlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbYLIUkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:40:11 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4536 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757719AbYLIUkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:40:08 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Date: Tue, 9 Dec 2008 12:39:46 -0800
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
       "David Miller" <davem@davemloft.net>,
       "Michael Chan" <mchan@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "jeff@garzik.org" <jeff@garzik.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] net (tg3): Fix failure to enable WoL by default
 when possible (rev. 2)
Message-ID: <20081209203946.GB29327@xw6200.broadcom.net>
References: <200812081250.59095.rjw@sisk.pl>
 <20081208190403.GA27341@xw6200.broadcom.net>
 <20081209.002007.203471603.davem@davemloft.net>
 <200812092126.35902.rjw@sisk.pl>
MIME-Version: 1.0
In-Reply-To: <200812092126.35902.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-WSS-ID: 6520081937G24977109-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure.  I'll do it.  Standby.

On Tue, Dec 09, 2008 at 12:26:35PM -0800, Rafael J. Wysocki wrote:
> On Tuesday, 9 of December 2008, David Miller wrote:
> > From: "Matt Carlson" <mcarlson@broadcom.com>
> > Date: Mon, 8 Dec 2008 11:04:03 -0800
> > 
> > > This has mostly been fixed up already in Dave Miller's tree.  In that
> > > tree, the WOL capability advertisements happens at the end of the
> > > tg3_get_eeprom_hw_cfg() function.
> > > 
> > > Your patch did uncover a bug though.  The removal of device_may_wakeup()
> > > in the first hunk of your patch still needs to be done.
> > 
> > Ok, can someone post a patch that takes care of that against
> > net-next-2.6?
> 
> Matt, are you going to take care of this or do you want me to do that?
> 
> Rafael
> 

