Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbZGPNrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbZGPNrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbZGPNrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:47:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53112 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbZGPNrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:47:07 -0400
Date: Thu, 16 Jul 2009 14:47:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>, alsa-devel@alsa-project.org,
       Jaroslav Kysela <erex@perex.cz>, LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [alsa-devel] [PATCH 01/06] Fix compilation warning for
	sound/soc/codecs/wm8400.c
Message-ID: <20090716134701.GD26770@sirena.org.uk>
References: <20090716130958.28045.71072.sendpatchset@subratamodak.linux.ibm.com> <20090716132308.GC9656@rakim.wolfsonmicro.main> <s5hzlb4n44x.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hzlb4n44x.wl%tiwai@suse.de>
X-Cookie: MOUNT TAPE U1439 ON B3, NO RING
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 03:34:06PM +0200, Takashi Iwai wrote:
> Mark Brown wrote:

> > In this case I suspect that whatever compiler you are using (none of
> > those I've tried with seem to be doing this) isn't able to figure out
> > that if we skip initialising the variable then we use exactly the same
> > condition to return from the function before we try to use the variable.

> I get compile warnings on gcc 4.4.0, too.

Ah, that's useful - my GCC 4.4 system is at home so I can't try that one
immediately.  Which architecture?
