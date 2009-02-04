Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbZBDTD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbZBDTD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761401AbZBDStm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:42 -0500
Received: from kroah.org ([198.145.64.141]:32921 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760357AbZBDStc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:32 -0500
Date: Wed, 4 Feb 2009 10:46:52 -0800
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
       alan@lxorguk.ukuu.org.uk, Corentin Chary <corentincj@iksaif.net>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [patch 32/41] asus-laptop: Add support for P30/P35
Message-ID: <20090204184652.GG25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="asus-laptop-add-support-for-p30-p35.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Torsten Krah <tkrah@fachschaft.imn.htwk-leipzig.de>

commit 4d0b856ef7eea5c03f4c1fa57793286ac068f4cd upstream.

Add support for P30/P35.

http://bugzilla.kernel.org/show_bug.cgi?id=10848

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/asus-laptop.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/asus-laptop.c
+++ b/drivers/misc/asus-laptop.c
@@ -139,6 +139,7 @@ ASUS_HANDLE(lcd_switch, "\\_SB.PCI0.SBRG
 	    "\\_SB.PCI0.PX40.ECD0._Q10",	/* L3C */
 	    "\\_SB.PCI0.PX40.EC0.Q10",	/* M1A */
 	    "\\_SB.PCI0.LPCB.EC0._Q10",	/* P30 */
+	    "\\_SB.PCI0.LPCB.EC0._Q0E", /* P30/P35 */
 	    "\\_SB.PCI0.PX40.Q10",	/* S1x */
 	    "\\Q10");		/* A2x, L2D, L3D, M2E */
 

