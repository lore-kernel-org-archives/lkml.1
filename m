Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZCUMWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZCUMWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbZCUMWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:22:08 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:47144 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZCUMWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:22:06 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH] p54: fix SoftLED compile dependencies
Date: Sat, 21 Mar 2009 13:22:01 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.29-rc8-wl; KDE/4.2.1; x86_64; ; )
Cc: Michael Buesch <mb@bu3sch.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au> <200903210057.47067.chunkeey@web.de> <87eiwre61a.fsf@litku.valot.fi>
In-Reply-To: <87eiwre61a.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903211322.01654.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX18LiaU6eA16qbFIYgttwnUPFXIAu5Tb8rgWwfGW
	COm6LAmteu/B09fcaBlnARyrb2s/WZ9bg4L9sqfCMrRIUX55i7
	XXfeGMPaM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 March 2009 07:36:33 Kalle Valo wrote:
> Christian Lamparter <chunkeey@web.de> writes:
> 
> > This patch fixes a compile problem when the MAC80211_LEDS
> > triggers are enabled but not LED class itself. 
> > (which is sort of pointless, but anyway...)
> 
> [...]
> 
> > @@ -17,31 +18,6 @@ config P54_USB
> >  	select CRC32
> >  	---help---
> >  	  This driver is for USB isl38xx based wireless cards.
> > -	  These are USB based adapters found in devices such as:
> > -
> > -	  3COM 3CRWE254G72
> > -	  SMC 2862W-G
> > -	  Accton 802.11g WN4501 USB
> > -	  Siemens Gigaset USB
> > -	  Netgear WG121
> > -	  Netgear WG111
> > -	  Medion 40900, Roper Europe
> > -	  Shuttle PN15, Airvast WM168g, IOGear GWU513
> > -	  Linksys WUSB54G
> > -	  Linksys WUSB54G Portable
> > -	  DLink DWL-G120 Spinnaker
> > -	  DLink DWL-G122
> > -	  Belkin F5D7050 ver 1000
> > -	  Cohiba Proto board
> > -	  SMC 2862W-G version 2
> > -	  U.S. Robotics U5 802.11g Adapter
> > -	  FUJITSU E-5400 USB D1700
> > -	  Sagem XG703A
> > -	  DLink DWL-G120 Cohiba
> > -	  Spinnaker Proto board
> > -	  Linksys WUSB54AG
> > -	  Inventel UR054G
> > -	  Spinnaker DUT
> 
> This change wasn't mentioned in the commit log. Did this get included
> by accident?
> 
heh true... should I add them back? after all this list hasn't changed in years
and we have a much nicer one on http://www.prism54.org/
( http://wireless.kernel.org/en/users/Drivers/p54/devices )

Regards,
	Chr
