Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbXJ2AJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbXJ2AJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 20:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbXJ2AJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 20:09:00 -0400
Received: from lixom.net ([66.141.50.11]:60746 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbXJ2AJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 20:09:00 -0400
Date: Sun, 28 Oct 2007 19:16:57 -0500
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, Alan@ozlabs.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] pcmcia: Remove replace kio_addr_t with unsigned int
	everywhere
Message-ID: <20071029001657.GA12709@lixom.net>
References: <20070914034854.1658a9cf.akpm@linux-foundation.org> <20070921221516.GA7926@lixom.net> <20070921233936.2aeb2504@the-village.bc.nu> <20070922062551.GE10625@parisc-linux.org> <20070922091303.GA12525@lst.de> <20071019201720.GA13234@lixom.net> <20071028134414.GF26943@isilmar.linta.de> <20071028201034.GB9472@lixom.net> <20071028201858.GA10048@lixom.net> <20071029105005.d85e212e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029105005.d85e212e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 10:50:05AM +1100, Stephen Rothwell wrote:
> Hi Olof,
> 
> diffstat output is very useful - especially for patches like this that
> touch lots of files.  It makes it easier for potential reviewers to see
> if they should be potential reviewers.  :-)

Hi,

Good point. I'll include it next time if I end up re-posting it. I hope
I won't have to. :-)

This is the diffstat from the posted patch:

 Documentation/pcmcia/driver-changes.txt |    4 +-
 drivers/bluetooth/bt3c_cs.c             |    2 -
 drivers/bluetooth/btuart_cs.c           |    2 -
 drivers/net/pcmcia/3c574_cs.c           |   49 ++++++++++++-------------
 drivers/net/pcmcia/3c589_cs.c           |   30 +++++++--------
 drivers/net/pcmcia/axnet_cs.c           |   26 ++++++-------
 drivers/net/pcmcia/fmvj18x_cs.c         |   23 ++++++-----
 drivers/net/pcmcia/nmclan_cs.c          |   24 ++++++------
 drivers/net/pcmcia/pcnet_cs.c           |   36 +++++++++---------
 drivers/net/pcmcia/smc91c92_cs.c        |   62 ++++++++++++++++----------------
 drivers/net/pcmcia/xirc2ps_cs.c         |   51 +++++++++++++-------------
 drivers/net/wireless/netwave_cs.c       |   24 ++++++------
 drivers/net/wireless/wavelan_cs.c       |   56 ++++++++++++++--------------
 drivers/pcmcia/i82092.c                 |    2 -
 drivers/pcmcia/i82365.c                 |   14 +++----
 drivers/pcmcia/m32r_cfc.c               |    7 ++-
 drivers/pcmcia/m32r_pcc.c               |    5 +-
 drivers/pcmcia/rsrc_nonstatic.c         |    5 +-
 drivers/serial/serial_cs.c              |    6 +--
 include/pcmcia/cs_types.h               |    1 
 include/pcmcia/ss.h                     |    6 +--
 21 files changed, 220 insertions(+), 215 deletions(-)



-Olof
