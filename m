Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbXLLOSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbXLLOSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXLLORt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:17:49 -0500
Received: from mxintern.schlund.de ([212.227.126.204]:54044 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbXLLORr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:17:47 -0500
Date: Wed, 12 Dec 2007 15:17:29 +0100
From: Anders Henke <anders.henke@1und1.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: miquels@cistron.nl, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, matthew@wil.cx,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2 check page: bad entry in directory) (fwd)
Message-ID: <20071212141729.GV6770@1und1.de>
Mail-Followup-To: Anders Henke <anders.henke@1und1.de>,
	Andrew Morton <akpm@linux-foundation.org>, miquels@cistron.nl,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	matthew@wil.cx, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <20071212105841.GN6770@1und1.de> <20071212033808.6fb92139.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212033808.6fb92139.akpm@linux-foundation.org>
Organization: 1&1 Internet AG
User-Agent: Mutt/1.5.13 (2006-08-11)
X-UI-Msg-Verification: 795d6962cb299600c6cbfc4fde1a55f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.12.2007 schrieb Andrew Morton:
> On Wed, 12 Dec 2007 11:58:41 +0100 Anders Henke <anders.henke@1und1.de> wrote:
> 
> > Hi,
> > 
> > I'd like to let you now that my boxes are running a 32-bit kernel, so
> > the 64-bit-uncleanliness shouldn't apply to my boxes; however,
> > 
> > http://www.miquels.cistron.nl/linux/dpt_i2o-64bit-2.6.23.patch
> > 
> > fixed the issue on my testbox.
> > 
> > I took a clean 2.6.23, applied patch, recompiled the kernel, reboot: works.
> 
> What a huge patch :(
> 
> We already reverted the offening patch so I assume that 2.6.24-rc5 is
> working for you?

Yes, the vanilla 2.6.24-rc5 works fine (at least it's booting :-).

Linux rdb140 2.6.24-rc5 #1 SMP Wed Dec 12 15:06:05 CET 2007 i686 GNU/Linux

> I guess we need to look at restoring "dpt_i2o: convert to SCSI hotplug
> model" and then absorbing what Miquel has done there.


I've tried 2.6.23 with

http://www.miquels.cistron.nl/linux/linux-2.6.23+24-dpt_i2o-dma64.patch

... and that's enough to make my boxes boot again.


Regards,

Anders
-- 
1&1 Internet AG            Enter any 11-digit prime number to continue.
Brauerstrasse 48           v://49.721.91374.50
D-76135 Karlsruhe          f://49.721.91374.225

Amtsgericht Montabaur HRB 6484
Vorstand: Henning Ahlert, Ralph Dommermuth, Matthias Ehrlich, Andreas Gauger,
Thomas Gottschlich, Matthias Greve, Robert Hoffmann, Norbert Lang, Achim Weiss
Aufsichtsratsvorsitzender: Michael Scheeren
