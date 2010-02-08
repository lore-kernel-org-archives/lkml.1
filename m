Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0BHJ0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:26:41 -0500
Received: from smtp.nokia.com ([192.100.122.230]:52343 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab0BHJ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:26:40 -0500
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Stephen Rothwell <sfr@canb.auug.org.au>,
       Tony Lindgren <tony@atomide.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaibhav Hiremath <hvaibhav@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
In-Reply-To: <20100208172521.abb500b4.sfr@canb.auug.org.au>
References: <20100208172521.abb500b4.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 08 Feb 2010 11:29:06 +0200
Message-ID: <1265621346.2433.27.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2010 09:26:18.0762 (UTC) FILETIME=[C50C1EA0:01CAA8A0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 07:25 +0100, ext Stephen Rothwell wrote:
> Hi Tomi,
> 
> Today's linux-next merge of the omap_dss2 tree got a conflict in
> arch/arm/mach-omap2/board-am3517evm.c between commit
> 13560d875d67c06239c82a6148c1b87075701fe9 ("AM3517: Enable basic I2C
> Support") from the omap tree and commit
> 56a3d0235cd50d14d7bd4d45e55d192aa0e78cac ("OMAP: AM3517: Enable DSS2 for
> AM3517EVM board") from the omap_dss2 tree.
> 
> Juts overlapping additions.   I fixed it up (see below) and can carry the
> fix as necessary.

Thanks. I guess we can't properly fix this until the patch from omap
tree goes into mainline.

Tony, do you think this current way, in which we have board file changes
in both linux-omap and the dss tree, is best we can do? Or should all
the board file changes go through linux-omap? I fear that we will have
conflicts with every new board.

> P.S. Tomi, this omap_dss2 commit only has your Acked-by not Signed-off-by.

Hmm, do you mean there's something wrong with that, or "jfyi"? Aren't I,
as a subsys maintainer, supposed to ack the patches?

 Tomi


