Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbZCWOQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbZCWOQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758186AbZCWOPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:15:47 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45511 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127AbZCWOPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:15:43 -0400
Date: Mon, 23 Mar 2009 10:13:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: Kalle Valo <kalle.valo@iki.fi>, Michael Buesch <mb@bu3sch.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: fix SoftLED compile dependencies
Message-ID: <20090323141320.GC3285@tuxdriver.com>
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au> <200903210057.47067.chunkeey@web.de> <87eiwre61a.fsf@litku.valot.fi> <200903211322.01654.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903211322.01654.chunkeey@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 01:22:01PM +0100, Christian Lamparter wrote:
> On Saturday 21 March 2009 07:36:33 Kalle Valo wrote:
> > Christian Lamparter <chunkeey@web.de> writes:
> > 
> > > This patch fixes a compile problem when the MAC80211_LEDS
> > > triggers are enabled but not LED class itself. 
> > > (which is sort of pointless, but anyway...)
> > 
> > [...]
> > 
> > > @@ -17,31 +18,6 @@ config P54_USB
> > >  	select CRC32
> > >  	---help---
> > >  	  This driver is for USB isl38xx based wireless cards.
> > > -	  These are USB based adapters found in devices such as:
> > > -
> > > -	  3COM 3CRWE254G72
> > > -	  SMC 2862W-G
> > > -	  Accton 802.11g WN4501 USB
> > > -	  Siemens Gigaset USB
> > > -	  Netgear WG121
> > > -	  Netgear WG111
> > > -	  Medion 40900, Roper Europe
> > > -	  Shuttle PN15, Airvast WM168g, IOGear GWU513
> > > -	  Linksys WUSB54G
> > > -	  Linksys WUSB54G Portable
> > > -	  DLink DWL-G120 Spinnaker
> > > -	  DLink DWL-G122
> > > -	  Belkin F5D7050 ver 1000
> > > -	  Cohiba Proto board
> > > -	  SMC 2862W-G version 2
> > > -	  U.S. Robotics U5 802.11g Adapter
> > > -	  FUJITSU E-5400 USB D1700
> > > -	  Sagem XG703A
> > > -	  DLink DWL-G120 Cohiba
> > > -	  Spinnaker Proto board
> > > -	  Linksys WUSB54AG
> > > -	  Inventel UR054G
> > > -	  Spinnaker DUT
> > 
> > This change wasn't mentioned in the commit log. Did this get included
> > by accident?
> > 
> heh true... should I add them back? after all this list hasn't changed in years
> and we have a much nicer one on http://www.prism54.org/
> ( http://wireless.kernel.org/en/users/Drivers/p54/devices )

Getting rid of them is fine, but it should probably be done in a different patch.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
