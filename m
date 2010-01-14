Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787Ab0ANW2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0ANW2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888Ab0ANW2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:47 -0500
Received: from kroah.org ([198.145.64.141]:60604 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab0ANW2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Daniel T Chen <crimsun@ubuntu.com>, Jaroslav Kysela <perex@perex.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/52] ALSA: ac97: Add Dell Dimension 2400 to Headphone/Line Jack Sense blacklist
Date: Thu, 14 Jan 2010 14:27:09 -0800
Message-Id: <1263508051-7868-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-29-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel T Chen <crimsun@ubuntu.com>

commit af9a75dd1a1f8a9aa406466cc8bb16208120488a upstream.

This model needs both 'Headphone Jack Sense' and 'Line Jack Sense' muted
for audible playback, so just add it to the ad1981 jack sense blacklist.

Tested-by: Pete <x41215201@gmail.com>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/ac97/ac97_patch.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/ac97/ac97_patch.c b/sound/pci/ac97/ac97_patch.c
index 7337abd..67ca440 100644
--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -1870,6 +1870,7 @@ static unsigned int ad1981_jacks_blacklist[] = {
 	0x10140554, /* Thinkpad T42p/R50p */
 	0x10140567, /* Thinkpad T43p 2668-G7U */
 	0x10140581, /* Thinkpad X41-2527 */
+	0x10280160, /* Dell Dimension 2400 */
 	0x104380b0, /* Asus A7V8X-MX */
 	0x11790241, /* Toshiba Satellite A-15 S127 */
 	0x144dc01a, /* Samsung NP-X20C004/SEG */
-- 
1.6.6

