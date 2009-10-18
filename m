Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbZJRHtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbZJRHtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 03:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZJRHtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 03:49:09 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:41184 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZJRHtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 03:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vjM2+ZA0TqbYDI6qv/lFCv1bTluzmsXU56B+lEvWlVZgH2gTG8qV56xFBJ+iZoxUfQ
         L/9Og043S5fCCvn+rngGUcnmq30o9iyURG5HARKNmuZGN2mEES0wK+5uaVCJu4P8R/Ep
         9f3W6E6QoxOY70HyeZDArU+qUK4F8719eAPi8=
Date: Sun, 18 Oct 2009 00:49:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.32-rc3
Message-ID: <20091018074909.GG3935@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Dmitry Torokhov (7):
      Input: synaptics - add another Protege M300 to rate blacklist
      Input: i8042 - make pnp_data_busted variable boolean instead of int
      Input: atkbd - restore resetting LED state at startup
      Input: atkbd - postpone restoring LED/repeat rate at resume
      Input: fix locking issue in /proc/bus/input/ handlers
      Input: i8042 - add Sony Vaio VGN-FZ240E to the nomux list
      Input: logips2pp - model 73 is actually TrackMan FX

Herton Ronaldo Krzesinski (1):
      Input: atkbd - consolidate force release quirks for volume keys

Roel Kluin (1):
      Input: hp_sdc_rtc - fix test in hp_sdc_rtc_read_rt()


Diffstat:
--------

 drivers/input/input.c                 |   65 ++++++++++++++++------
 drivers/input/keyboard/atkbd.c        |   96 +++++++++++++++++++--------------
 drivers/input/misc/hp_sdc_rtc.c       |    2 +-
 drivers/input/mouse/logips2pp.c       |    2 +-
 drivers/input/mouse/synaptics.c       |   10 ++++
 drivers/input/serio/i8042-x86ia64io.h |   13 ++++-
 6 files changed, 127 insertions(+), 61 deletions(-)

-- 
Dmitry

