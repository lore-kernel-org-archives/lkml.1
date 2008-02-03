Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbYBCFba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbYBCFba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 00:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYBCFbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 00:31:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58285 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbYBCFbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 00:31:22 -0500
Message-ID: <47A55176.8050004@cn.fujitsu.com>
Date: Sun, 03 Feb 2008 13:30:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: tiwai@suse.de
CC: LKML <linux-kernel@vger.kernel.org>
Subject: latest git compile error in sound/drivers/opl3/opl3_synth.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sound/drivers/opl3/opl3_synth.c: In function 'snd_opl3_find_patch':
sound/drivers/opl3/opl3_synth.c:308: error: 'OPL3_PATCH_HASH_SIZE' undeclared (first use in this function)
sound/drivers/opl3/opl3_synth.c:308: error: (Each undeclared identifier is reported only once
sound/drivers/opl3/opl3_synth.c:308: error: for each function it appears in.)
sound/drivers/opl3/opl3_synth.c:311: error: 'struct snd_opl3' has no member named 'patch_table'
sound/drivers/opl3/opl3_synth.c:323: error: 'struct snd_opl3' has no member named 'patch_table'
sound/drivers/opl3/opl3_synth.c:324: error: 'struct snd_opl3' has no member named 'patch_table'
sound/drivers/opl3/opl3_synth.c: In function 'snd_opl3_clear_patches':
sound/drivers/opl3/opl3_synth.c:335: error: 'OPL3_PATCH_HASH_SIZE' undeclared (first use in this function)
sound/drivers/opl3/opl3_synth.c:337: error: 'struct snd_opl3' has no member named 'patch_table'
sound/drivers/opl3/opl3_synth.c:342: error: 'struct snd_opl3' has no member named 'patch_table'
sound/drivers/opl3/opl3_synth.c:342: error: 'struct snd_opl3' has no member named 'patch_table'

seems it's caused by the following config options:
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OPL3_LIB=m

