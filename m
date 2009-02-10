Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbZBJTLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbZBJTLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZBJTDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:49 -0500
Received: from kroah.org ([198.145.64.141]:53837 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755477AbZBJTDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:47 -0500
Date: Tue, 10 Feb 2009 11:00:24 -0800
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
       alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
       Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>
Subject: [patch 21/53] eeepc-laptop: Add support for extended hotkeys
Message-ID: <20090210190024.GV14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="eeepc-laptop-add-support-for-extended-hotkeys.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Matthew Garrett <mjg59@srcf.ucam.org>

commit b5f6f26550700445dcc125bbf75b9104e779d353 upstream.

Newer Eees have extra hotkeys above the function keys. This patch adds support
for sending them through the input layer.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/eeepc-laptop.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/misc/eeepc-laptop.c
+++ b/drivers/misc/eeepc-laptop.c
@@ -161,6 +161,10 @@ static struct key_entry eeepc_keymap[] =
 	{KE_KEY, 0x13, KEY_MUTE },
 	{KE_KEY, 0x14, KEY_VOLUMEDOWN },
 	{KE_KEY, 0x15, KEY_VOLUMEUP },
+	{KE_KEY, 0x1a, KEY_COFFEE },
+	{KE_KEY, 0x1b, KEY_ZOOM },
+	{KE_KEY, 0x1c, KEY_PROG2 },
+	{KE_KEY, 0x1d, KEY_PROG3 },
 	{KE_KEY, 0x30, KEY_SWITCHVIDEOMODE },
 	{KE_KEY, 0x31, KEY_SWITCHVIDEOMODE },
 	{KE_KEY, 0x32, KEY_SWITCHVIDEOMODE },

