Return-Path: <linux-kernel-owner+w=401wt.eu-S1764704AbYHDUbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764704AbYHDUbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759738AbYHDUa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:30:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:46130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbYHDUa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:30:57 -0400
Date: Mon, 4 Aug 2008 13:16:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 28/33] ALSA: Add more fallbacks to OSS PHONEOUT mixer map
Message-ID: <20080804201619.GC1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-add-more-fallbacks-to-oss-phoneout-mixer-map.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6c4cc3a8ed15aacc06a5fd369639fef633cee2bc upstream

Added more fallbacks to OSS PHONEOUT mixer mapping.  This corresponds
to the speaker output in general, so now "Mono" and "Speaker" are
assigned.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/oss/mixer_oss.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -1257,6 +1257,8 @@ static void snd_mixer_oss_build(struct s
 		{ SOUND_MIXER_DIGITAL3,	"Digital",		2 },
 		{ SOUND_MIXER_PHONEIN,	"Phone",		0 },
 		{ SOUND_MIXER_PHONEOUT,	"Master Mono",		0 },
+		{ SOUND_MIXER_PHONEOUT,	"Speaker",		0 }, /*fallback*/
+		{ SOUND_MIXER_PHONEOUT,	"Mono",			0 }, /*fallback*/
 		{ SOUND_MIXER_PHONEOUT,	"Phone",		0 }, /* fallback */
 		{ SOUND_MIXER_VIDEO,	"Video",		0 },
 		{ SOUND_MIXER_RADIO,	"Radio",		0 },

-- 
