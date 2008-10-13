Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYJMVgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYJMVgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYJMVfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:35:53 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:37396 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYJMVfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:35:52 -0400
Date: Mon, 13 Oct 2008 23:35:39 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [git pull] CRIS update for 2.6.28
Message-ID: <20081013213539.GT15259@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Just some file moves in this pull-request.

The following changes since commit d17ffb4c9d86194bb74cbc30f4b65de59c27f6cd:
  Jesper Nilsson (1):
        Merge branch 'cris_debug_port_fix' into cris

are available in the git repository at:

  /pub/scm/cris.git for-linus

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

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
