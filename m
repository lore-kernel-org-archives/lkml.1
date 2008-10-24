Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbYJXEry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbYJXEry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYJXEjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:40 -0400
Received: from kroah.org ([198.145.64.141]:51972 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751375AbYJXEjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:35 -0400
Date: Thu, 23 Oct 2008 21:35:24 -0700
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
       alan@lxorguk.ukuu.org.uk, Yanqing Liu <yanqing_liu@dell.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       shyam iyer <shyam_iyer@dell.com>
Subject: [patch 25/27] SCSI: scsi_dh: add Dell product information into
	rdac device handler
Message-ID: <20081024043524.GZ30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-scsi_dh-add-dell-product-information-into-rdac-device-handler.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Yanqing_Liu@Dell.com <Yanqing_Liu@Dell.com>

commit 650849d71ca05d55a1553fe42fb21af9dce5612b upstream.

Add Dell Powervault storage arrays into device list of rdac device
handler.

Signed-off-by: Yanqing Liu <yanqing_liu@dell.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: shyam iyer <shyam_iyer@dell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/device_handler/scsi_dh_rdac.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -590,6 +590,8 @@ static const struct scsi_dh_devlist rdac
 	{"STK", "OPENstorage D280"},
 	{"SUN", "CSM200_R"},
 	{"SUN", "LCSM100_F"},
+	{"DELL", "MD3000"},
+	{"DELL", "MD3000i"},
 	{NULL, NULL},
 };
 

-- 
