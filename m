Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZBJTMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZBJTMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbZBJTDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:53 -0500
Received: from kroah.org ([198.145.64.141]:53888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755614AbZBJTDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:51 -0500
Date: Tue, 10 Feb 2009 11:00:33 -0800
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
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@linux.ie>
Subject: [patch 25/53] agp/intel: =?iso-8859-1?Q?Fi?=
	=?iso-8859-1?Q?x_broken_=AE?= symbol in device name.
Message-ID: <20090210190033.GZ14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="agp-intel-fix-broken-symbol-in-device-name.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Eric Anholt <eric@anholt.net>

commit b854b2ab959e8175d75e01cf8ed452ed2624d0c8 upstream.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -2160,7 +2160,7 @@ static const struct intel_driver_descrip
 	{ PCI_DEVICE_ID_INTEL_Q33_HB, PCI_DEVICE_ID_INTEL_Q33_IG, 0, "Q33",
 		NULL, &intel_g33_driver },
 	{ PCI_DEVICE_ID_INTEL_GM45_HB, PCI_DEVICE_ID_INTEL_GM45_IG, 0,
-	    "Mobile Intel? GM45 Express", NULL, &intel_i965_driver },
+	    "Mobile Intel® GM45 Express", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_IGD_E_HB, PCI_DEVICE_ID_INTEL_IGD_E_IG, 0,
 	    "Intel Integrated Graphics Device", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_Q45_HB, PCI_DEVICE_ID_INTEL_Q45_IG, 0,

