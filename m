Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYJQGeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYJQGeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYJQGd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:33:59 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:56357 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYJQGd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:33:58 -0400
Date: Fri, 17 Oct 2008 08:33:45 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] CRIS update for 2.6.28
Message-ID: <20081017063345.GB24715@axis.com>
References: <20081013213539.GT15259@axis.com> <alpine.LFD.2.00.0810141230310.3288@nehalem.linux-foundation.org> <20081014202140.GA4395@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014202140.GA4395@axis.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 10:21:40PM +0200, Jesper Nilsson wrote:

...and it seems my mail config was not correct, causing most mail
servers to treat the mail as spam... Third try is the charm?

> On Mon, 13 Oct 2008, Jesper Nilsson wrote:
> > Just some file moves in this pull-request.
> > The following changes since commit d17ffb4c9d86194bb74cbc30f4b65de59c27f6cd:
> >   Jesper Nilsson (1):
> >         Merge branch 'cris_debug_port_fix' into cris
> >
> > are available in the git repository at:
> >
> >   /pub/scm/cris.git for-linus
> 
> Umm. Ehh. Where?

Ah, right, much easier with an external repo. Sorry 'bout that.

The following changes since commit d17ffb4c9d86194bb74cbc30f4b65de59c27f6cd:
  Jesper Nilsson (1):
        Merge branch 'cris_debug_port_fix' into cris

are available in the git repository at:

        git://www.jni.nu/cris.git for-linus

Adrian Bunk (1):
      CRIS: proper defconfig setup

Jesper Nilsson (1):
      [CRIS] Rename boot-linkscripts and fix the path to them.

 arch/cris/Makefile                                 |    2 ++
 arch/cris/arch-v10/boot/compressed/Makefile        |    2 +-
 .../compressed/{decompress.ld => decompress.lds}   |    0
 arch/cris/arch-v10/boot/rescue/Makefile            |    2 +-
 .../arch-v10/boot/rescue/{rescue.ld => rescue.lds} |    0
 arch/cris/arch-v32/boot/compressed/Makefile        |    2 +-
 .../compressed/{decompress.ld => decompress.lds}   |    0
 arch/cris/arch-v32/boot/rescue/Makefile            |    2 +-
 .../arch-v32/boot/rescue/{rescue.ld => rescue.lds} |    0
 arch/cris/{ => configs}/artpec_3_defconfig         |    0
 .../defconfig => configs/etrax-100lx_defconfig}    |    0
 .../etrax-100lx_v2_defconfig}                      |    0
 arch/cris/{ => configs}/etraxfs_defconfig          |    0
 13 files changed, 6 insertions(+), 4 deletions(-)
 rename arch/cris/arch-v10/boot/compressed/{decompress.ld => decompress.lds} (100%)
 rename arch/cris/arch-v10/boot/rescue/{rescue.ld => rescue.lds} (100%)
 rename arch/cris/arch-v32/boot/compressed/{decompress.ld => decompress.lds} (100%)
 rename arch/cris/arch-v32/boot/rescue/{rescue.ld => rescue.lds} (100%)
 rename arch/cris/{ => configs}/artpec_3_defconfig (100%)
 rename arch/cris/{arch-v10/defconfig => configs/etrax-100lx_defconfig} (100%)
 rename arch/cris/{defconfig => configs/etrax-100lx_v2_defconfig} (100%)
 rename arch/cris/{ => configs}/etraxfs_defconfig (100%)

>                 Linus

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
