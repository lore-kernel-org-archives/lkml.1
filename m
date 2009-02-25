Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbZBYV0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbZBYV0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZBYV0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:26:41 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:37551 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZBYV0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:26:40 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 0/7] sound: fix sparse warnings
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Feb 2009 22:26:34 +0100
Message-ID: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes some sparse warnings in sound/.

---

Hannes Eder (7):
      sound/oss: fix sparse warning: symbol shadows an earlier one
      sound/oss: fix sparse warnings: different signedness
      sound/drivers/vx: fix sparse warning: different signedness
      sound/pci/emu10k1: fix sparse warning: different signedness
      sound/pci/hda: fix sparse warning: different signedness
      sound/usb/usx2y: fix sparse warning: do-while statement is not a compound ...
      sound/usb/usx2y: fix sparse warning: Should it be static?


 sound/drivers/vx/vx_uer.c        |    2 +-
 sound/oss/pss.c                  |   12 ++++++------
 sound/oss/sequencer.c            |    3 +--
 sound/pci/emu10k1/emu10k1_main.c |   10 ++++------
 sound/pci/hda/hda_local.h        |    2 +-
 sound/usb/usx2y/usX2Yhwdep.c     |    3 ---
 sound/usb/usx2y/usbusx2y.c       |    4 ++--
 sound/usb/usx2y/usx2yhwdeppcm.h  |    2 ++
 8 files changed, 17 insertions(+), 21 deletions(-)
