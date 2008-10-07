Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbYJGBGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbYJGBGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbYJGArS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:47:18 -0400
Received: from postal1-e0.whoi.edu ([128.128.76.87]:51765 "EHLO
	postal1.whoi.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712AbYJGArR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:47:17 -0400
X-Greylist: delayed 1908 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2008 20:47:17 EDT
Message-ID: <48EAAA18.70204@whoi.edu>
Date: Mon, 06 Oct 2008 20:15:20 -0400
From: Ned Forrester <nforrester@whoi.edu>
Organization: Woods Hole Oceanographic Institution
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Vernon Sauder <vernoninhand@gmail.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Rapoport <mike@compulab.co.il>
Subject: Re: [patch 02/28] pxa2xx_spi: dma bugfixes
References: <20081006225949.357365087@mini.kroah.org> <20081006231701.GC20567@suse.de>
In-Reply-To: <20081006231701.GC20567@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 2.6.25-stable review patch.  If anyone has any objections, please let us
> know.
> 
> ------------------
> From: Ned Forrester <nforrester@whoi.edu>
> 
> commit 7e96445533ac3f4f7964646a202ff3620602fab4 upstream

This patch also needs the patch:

---

[spi-devel-general] [patch 2.6.27-rc7] pxa2xx_spi buildfix

From: Mike Rapoport <mike@compulab.co.il>

This patch fixes a build error in the pxa2xx-spi driver,
introduced by commit 7e96445533ac3f4f7964646a202ff3620602fab4

[dbrownell@users.sourceforge.net: fix sparse warning too ]

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Eric Miao <eric.miao@marvell.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
for 2.6.27-final, please ...

 drivers/spi/pxa2xx_spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

I will forward it to stable@kernel.org
I don't think the original patch was forwarded there.

-- 
Ned Forrester                                       nforrester@whoi.edu
Oceanographic Systems Lab                                  508-289-2226
Applied Ocean Physics and Engineering Dept.
Woods Hole Oceanographic Institution          Woods Hole, MA 02543, USA
http://www.whoi.edu/sbl/liteSite.do?litesiteid=7212
http://www.whoi.edu/hpb/Site.do?id=1532
http://www.whoi.edu/page.do?pid=10079

