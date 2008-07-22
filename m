Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYGVX3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYGVX3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbYGVXUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:20:19 -0400
Received: from ns.suse.de ([195.135.220.2]:53263 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbYGVXUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:20:17 -0400
Date: Tue, 22 Jul 2008 16:16:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcin Obara <marcin_obara@users.sourceforge.net>,
       Marcel Selhorst <tpm@selhorst.net>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: [patch 34/47] tpm: add Intel TPM TIS device HID
Message-ID: <20080722231650.GI8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tpm-add-intel-tpm-tis-device-hid.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Marcin Obara <marcin_obara@users.sourceforge.net>

commit fb0e7e11d017beb5f0b1fa25bc51e49e65c46d67 upstream

This patch adds Intel TPM TIS device HID:  ICO0102

Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
Acked-by: Marcel Selhorst <tpm@selhorst.net>
Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm_tis.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -623,6 +623,7 @@ static struct pnp_device_id tpm_pnp_tbl[
 	{"IFX0102", 0},		/* Infineon */
 	{"BCM0101", 0},		/* Broadcom */
 	{"NSC1200", 0},		/* National */
+	{"ICO0102", 0},		/* Intel */
 	/* Add new here */
 	{"", 0},		/* User Specified */
 	{"", 0}			/* Terminator */

-- 
