Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYBVO2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYBVO2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYBVO2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:28:16 -0500
Received: from zeratul.whoi.edu ([128.128.76.62]:44078 "EHLO mx1.whoi.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYBVO2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:28:15 -0500
X-Greylist: delayed 1220 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 09:28:15 EST
Message-ID: <47BEDBFB.5040305@whoi.edu>
Date: Fri, 22 Feb 2008 09:28:11 -0500
From: Ned Forrester <nforrester@whoi.edu>
Organization: Woods Hole Oceanographic Institution
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: marc.pignat@hevs.ch, david-b@pacbell.net,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [spi-devel-general] [PATCH] atmel_spi: support zero length	transfer
References: <200802211026.17816.marc.pignat@hevs.ch>	<20080221192334.EE97A230A58@adsl-69-226-248-13.dsl.pltn13.pacbell.net>	<200802221030.32263.marc.pignat@hevs.ch> <20080222.231510.56565462.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080222.231510.56565462.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:

> If the driver could not handle zero length transfer, then the driver
> should reject it (just like unsupported transfer mode).  Then the
> behavior will be 'assert chip select and wait some time' or 'rejected
> by the driver'.

This would be OK.  It would not be hard to fix pxa2xx_spi, for example,
to reject zero-length transfers in DMA mode, as long as it is acceptable
to reject the message in mid-message.  If it were necessary to scan a
whole message for zero-length transfers and refuse to queue an offending
message, then that adds burden to all messages.

-- 
Ned Forrester                                       nforrester@whoi.edu
Oceanographic Systems Lab                                  508-289-2226
Applied Ocean Physics and Engineering Dept.
Woods Hole Oceanographic Institution          Woods Hole, MA 02543, USA
http://www.whoi.edu/sbl/liteSite.do?litesiteid=7212
http://www.whoi.edu/hpb/Site.do?id=1532
http://www.whoi.edu/page.do?pid=10079

