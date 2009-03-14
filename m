Return-Path: <linux-kernel-owner+w=401wt.eu-S1763408AbZCNBdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763408AbZCNBdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZCNBUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:38 -0400
Received: from kroah.org ([198.145.64.141]:35107 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753344AbZCNBUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:36 2009
Message-Id: <20090314011036.852308445@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:14 -0700
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
Subject: [patch 037/114] ALSA: hda - Fix digital mic on dell-m4-1 and dell-m4-3
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-fix-digital-mic-on-dell-m4-1-and-dell-m4-3.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ea18aa464452c3e6550320d247c0306aaa2d156f upstream.

Fix num_dmuxes initialization for dell-m4-1 and dell-m4-3 models
of IDT 92HD71bxx codec, which was wrongly set to zero.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4668,7 +4668,7 @@ again:
 	case STAC_DELL_M4_3:
 		spec->num_dmics = 1;
 		spec->num_smuxes = 0;
-		spec->num_dmuxes = 0;
+		spec->num_dmuxes = 1;
 		break;
 	default:
 		spec->num_dmics = STAC92HD71BXX_NUM_DMICS;


