Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZCNBoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZCNBoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZCNBVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:14 -0400
Received: from kroah.org ([198.145.64.141]:35470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754323AbZCNBUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:41 2009
Message-Id: <20090314011041.472610401@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:45 -0700
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
       alan@lxorguk.ukuu.org.uk, David Altobelli <david.altobelli@hp.com>
Subject: [patch 068/114] hpilo: new pci device
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=hpilo-new-pci-device.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Altobelli <david.altobelli@hp.com>

commit 31d8b5631f095cb7100cfccc95c801a2547ffe2b upstream.

Future iLO devices will have an HP vendor id.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/hpilo.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -710,6 +710,7 @@ out:
 
 static struct pci_device_id ilo_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB204) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3307) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ilo_devices);


