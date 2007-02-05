Return-Path: <linux-kernel-owner+w=401wt.eu-S1751796AbXBEQyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbXBEQyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbXBEQyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:54:36 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:39550 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbXBEQye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=jwR5HSnXffV73pnUWhjggbOwXPah2+4uFVliYlERY5ZajGiBTAbuAvhoabA+r377RJwfIV8MderCrDOAroNdbY1NoELw/d/0/lP9K5xS7AL/UOaUf5yLyDpj9yIMc/EhqrmTkCi4K78K6ir3vfBKvA3TOS9RqwtuPB14/aYb8OY=
Date: Mon, 5 Feb 2007 18:54:29 +0200
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 00] A series of patches to use ARRAY_SIZE in `net' drivers
Message-ID: <20070205165429.GD3896@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Follows is a sereis of patches to use ARRAY_SIZE macro in drivers/net. 
Patches are sent separately according to their maintaners as replies to 
this thread.

 apne.c                     |    2 +-
 arm/am79c961a.c            |    2 +-
 atarilance.c               |    2 +-
 cs89x0.c                   |    6 +++---
 e1000/e1000_ethtool.c      |    2 +-
 fec_8xx/fec_mii.c          |    4 ++--
 ibm_emac/ibm_emac_debug.c  |    8 ++++----
 irda/actisys-sir.c         |    3 ++-
 ixgb/ixgb_param.c          |    2 +-
 lp486e.c                   |    2 +-
 ne-h8300.c                 |    2 +-
 ne.c                       |    2 +-
 ne2.c                      |    2 +-
 ne2k-pci.c                 |    2 +-
 netxen/netxen_nic_hw.c     |    2 +-
 pcmcia/axnet_cs.c          |    2 +-
 pcmcia/pcnet_cs.c          |    2 +-
 sk98lin/skgemib.c          |    4 +++-
 sk98lin/skgesirq.c         |    3 ++-
 skfp/smt.c                 |    3 ++-
 skfp/srf.c                 |    6 ++++--
 wireless/airo.c            |    4 ++--
 wireless/hostap/hostap.h   |    3 ++-
 wireless/ipw2100.c         |   14 ++++++--------
 wireless/prism54/oid_mgt.c |    4 +++-
 wireless/wavelan.p.h       |    2 +-
 zorro8390.c                |    2 +-
 27 files changed, 50 insertions(+), 42 deletions(-)

Thanks,
-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
