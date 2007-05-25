Return-Path: <linux-kernel-owner+w=401wt.eu-S1761448AbXEYLu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448AbXEYLu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbXEYLuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:50:51 -0400
Received: from twin.jikos.cz ([213.151.79.26]:33903 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbXEYLuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:50:50 -0400
Date: Fri, 25 May 2007 13:50:37 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Yoann Padioleau <padator@wanadoo.fr>
cc: kernel-janitors@lists.osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] potential parse error in ifdef 
In-Reply-To: <87abvtfi9w.fsf@wanadoo.fr>
Message-ID: <Pine.LNX.4.64.0705251349330.8531@twin.jikos.cz>
References: <87abvtfi9w.fsf@wanadoo.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Yoann Padioleau wrote:

> I have made a tool to parse the kernel that does not pre-process the
> source. That means that my parser tries to parse all the code, including
> code in the #else branch or code that is not often compiled because
> the driver is not very used (or not used at all). So, my parser
> sometimes reports parse error not originally detected by gcc. 
> Here is my (first) patch.
>  drivers/char/watchdog/ixp2000_wdt.c |    2 +-
>  drivers/mtd/devices/pmc551.c        |    2 +-
>  drivers/mtd/nand/autcpu12.c         |    2 +-
>  drivers/mtd/nand/ppchameleonevb.c   |    2 +-
>  drivers/net/amd8111e.c              |    2 +-
>  drivers/net/skfp/smt.c              |    2 +-
>  drivers/scsi/aic7xxx/aic79xx_core.c |    2 +-
>  sound/arm/sa11xx-uda1341.c          |    2 +-
>  8 files changed, 8 insertions(+), 8 deletions(-)

As these are totally independent fixes across various subsystems, you 
should probably split the patch into per-subsystem patches and submit them 
separately.

Thanks,

-- 
Jiri Kosina
