Return-Path: <linux-kernel-owner+w=401wt.eu-S1762755AbZDBO76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755AbZDBO76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761434AbZDBO50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:57:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:54218 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760989AbZDBO5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:57:25 -0400
Content-Type: multipart/mixed; boundary="===============1720321343=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,314,1235980800"; 
   d="scan'208";a="678190901"
Message-Id: <20090402145718.891270000@intel.com>
References: <20090402145455.597376000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 16:55:04 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 09/18] x86, ds: fix compiler warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1720321343==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds_selftest.printk.patch

Size_t is defined differently on i386 and x86_64.
Change type to avoid compiler warning.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ds_selftest.c |    2 	1 +	1 -	0 !
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/arch/x86/kernel/ds_selftest.c
===================================================================
--- a/arch/x86/kernel/ds_selftest.c
+++ b/arch/x86/kernel/ds_selftest.c
@@ -87,7 +87,7 @@ static int ds_selftest_bts_read(struct b
 	/* Now to the test itself. */
 	for (at = from; (void *)at < to; at += trace->ds.size) {
 		struct bts_struct bts;
-		size_t index;
+		unsigned long index;
 		int error;
 
 		if (((void *)at - trace->ds.begin) % trace->ds.size) {

-- 

--===============1720321343==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--===============1720321343==--
