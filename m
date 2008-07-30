Return-Path: <linux-kernel-owner+w=401wt.eu-S1762361AbYG3PIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762361AbYG3PIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYG3PIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:08:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbYG3PIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:08:22 -0400
Date: Wed, 30 Jul 2008 17:08:20 +0200
From: Karsten Keil <kkeil@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Karsten Keil <kkeil@suse.de>, isdn4linux@listserv.isdn4linux.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN cleanup user interface
Message-ID: <20080730150820.GA9491@pingi.kke.suse.de>
References: <20080729195637.GB25929@pingi.kke.suse.de> <1217362946.27925.137.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217362946.27925.137.camel@pmac.infradead.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 09:22:26PM +0100, David Woodhouse wrote:
> On Tue, 2008-07-29 at 21:56 +0200, Karsten Keil wrote:
> > Please pull from git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master
> > 
> > The channelmap should have the same size on 32 and 64 bit
> > systems. Thanks to David Woodhouse for spotting this.
> > 
> > Signed-off-by: Karsten Keil <kkeil@suse.de>
> 
> Er, isn't that still broken? Consider 32-bit userspace on 64-bit kernel,
> big-endian.
> 

URGH, you are right, using the bit operations here is not a good idea at
all and currently we also need not to be atomic for this map so we can use a
bytearray and simple operation here.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
