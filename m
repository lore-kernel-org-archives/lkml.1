Return-Path: <linux-kernel-owner+w=401wt.eu-S1765248AbXEVIQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765248AbXEVIQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbXEVIQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:16:36 -0400
Received: from aun.it.uu.se ([130.238.12.36]:62968 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673AbXEVIQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:16:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18002.42712.248696.433735@alkaid.it.uu.se>
Date: Tue, 22 May 2007 10:16:24 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Hans A Eide <h.a.eide@usit.uio.no>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sata_promise: Port enumeration order - SATA 150 TX4,
In-Reply-To: <CEAADB30-FB4E-4F2B-BBF9-DD085FBF9B55@usit.uio.no>
References: <CEAADB30-FB4E-4F2B-BBF9-DD085FBF9B55@usit.uio.no>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[added cc:linux-ide]

Hans A Eide writes:
 > 
 >  > Evan Harris wrote:
 >  >>
 >  >> I have a card that mirrors this one from your list:
 >  >>
 >  >> Retail name: SATA300 TX4
 >  >> Chip label: PDC40718-GP  SATAII300
 >  >> Vendor-Device number: 105a:3d17 (rev 02)
 >  >>
 >  >> Through testing, I've found linux 2.6.16 and 2.6.17 find the  
 > ports in
 >  >> this order (the list is ordered by linux detection):
 >  >>
 >  >> 1. silkscreen port 3
 >  >> 2. silkscreen port 2
 >  >> 3. silkscreen port 4
 >  >> 4. silkscreen port 1
 >  >>> NOTE: the patch I have submitted (
 >  >>> http://marc.theaimsgroup.com/?l=linux- 
 > ide&m=114082978311290&w=2 ) is a
 >  >>> solution that doesn't know about the older Promise SATA  
 > controllers,
 >  >>> which are not affected with the "new wiring" problem, so the older
 >  >>> controllers will appear screwed if you use it.
 >  >>>
 >  >>> Hopefully we will collect enough info about all the SATA Promise
 >  >>> controllers to distinguish the new and the old wiring controllers,
 >  >>> then produce a new patch that will be a correct solution to the  
 > "new
 >  >>> wiring" problem.
 >  >
 >  > Mikael Pettersson has been doing some excellent work recently on
 >  > sata_promise.  If enough data has been collected on this sata_promise
 >  > port enumeration problem, maybe the data could be collated and  
 > proposed
 >  > via Mikael as a patch?
 >  >
 >  > 	Jeff
 > 
 > Sorry, any updates on this?

You should have posted this to linux-ide not linux-scsi.

The Promise SATAII TX4 port enumeration issue is fixed in
current 2.6.22-rc kernels. A patch for 2.6.21 can be found
in <http://marc.info/?l=linux-ide&m=117728096711046&w=2>.

/Mikael
