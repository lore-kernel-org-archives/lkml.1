Return-Path: <linux-kernel-owner+w=401wt.eu-S965540AbXC1Rz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965540AbXC1Rz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965570AbXC1Rz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:55:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:9688 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965540AbXC1Rz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:55:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,341,1170662400"; 
   d="scan'208"; a="220943347:sNHT28415660"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C77162.535DE751"
Subject: RE: 2.6.21-rc5-mm2
Date: Wed, 28 Mar 2007 10:55:51 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F52A9F13@scsmsx415.amr.corp.intel.com>
In-Reply-To: <200703281942.10367.christiand59@web.de>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.21-rc5-mm2
thread-index: AcdxYXJZ7tkBXIsTTk2zuGmaxGJL0QAAL7dA
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Christian" <christiand59@web.de>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Mar 2007 17:55:52.0455 (UTC) FILETIME=[53797170:01C77162]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C77162.535DE751
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


=20
Patch attached here should fix the issue.

Thanks,
Venki


>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org=20
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Christian
>Sent: Wednesday, March 28, 2007 10:42 AM
>To: linux-kernel@vger.kernel.org
>Subject: Re: 2.6.21-rc5-mm2
>
>Hello lkml!
>
>I have a problem with the new cpuidle infrastructure. My=20
>system locks up hard=20
>on bootup with the message ACPI cpuidle could not initialize=20
>cpu0 and cpu1.=20
>When I deselect cpuidle in the kernel config everything works=20
>fine again.
>My system is AMD64 X2 with NForce4 chipset.
>
>-Christian
>-
>To unsubscribe from this list: send the line "unsubscribe=20
>linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

------_=_NextPart_001_01C77162.535DE751
Content-Type: message/rfc822
Content-Transfer-Encoding: 7bit

X-MimeOLE: Produced By Microsoft Exchange V6.5
Received: from scsmsx412.amr.corp.intel.com ([10.3.90.31]) by scsmsx415.amr.corp.intel.com with Microsoft SMTPSVC(6.0.3790.1830); Mon, 26 Mar 2007 22:38:49 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Received: from fmsmsx334.amr.corp.intel.com ([132.233.42.1]) by scsmsx412.amr.corp.intel.com with Microsoft SMTPSVC(6.0.3790.1830); Mon, 26 Mar 2007 22:38:49 -0700
Received: from fmsmga002.fm.intel.com ([10.253.24.26]) by fmsmsx334.amr.corp.intel.com with Microsoft SMTPSVC(6.0.3790.1830); Mon, 26 Mar 2007 22:38:49 -0700
Received: from orsmga102-1.jf.intel.com (HELO mga09.intel.com) ([10.7.208.27])  by fmsmga002.fm.intel.com with ESMTP; 26 Mar 2007 22:38:49 -0700
Received: from smtp.osdl.org ([65.172.181.24])  by mga09.intel.com with ESMTP; 26 Mar 2007 22:38:48 -0700
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6]) by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l2R5clU2016698 (version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO); Mon, 26 Mar 2007 22:38:47 -0700
Received: from localhost.localdomain (shell0.pdx.osdl.net [10.9.0.31]) by shell0.pdx.osdl.net (8.13.1/8.11.6) with ESMTP id l2R5ckE5007930; Mon, 26 Mar 2007 22:38:47 -0700
Content-class: urn:content-classes:message
Subject: [patch 1/4] cuidle: fix boot hang
Date: Mon, 26 Mar 2007 22:38:46 -0700
Message-ID: <200703270538.l2R5ckE5007930@shell0.pdx.osdl.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/4] cuidle: fix boot hang
thread-index: AcdwMjIR2LkHaUYTRMesL5af2HAMEg==
From: <akpm@linux-foundation.org>
To: <lenb@kernel.org>
Cc: <linux-acpi@vger.kernel.org>,
	<akpm@linux-foundation.org>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	<larry.finger@lwfinger.net>

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Patch for cpuidle boot hang reported by Larry Finger here.
http://www.ussg.iu.edu/hypermail/linux/kernel/0703.2/2025.html

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Larry Finger <larry.finger@lwfinger.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c |   26 +++++++++++++++++++-------
 drivers/cpuidle/driver.c  |    4 ++--
 2 files changed, 21 insertions(+), 9 deletions(-)

diff -puN drivers/cpuidle/cpuidle.c~cpuidle-fix-boot-hang =
drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpuidle-fix-boot-hang
+++ a/drivers/cpuidle/cpuidle.c
@@ -119,6 +119,7 @@ static int cpuidle_add_device(struct sys
=20
 	dev =3D &per_cpu(cpuidle_devices, cpu);
=20
+	dev->cpu =3D cpu;
 	mutex_lock(&cpuidle_lock);
 	if (cpu_is_offline(cpu)) {
 		mutex_unlock(&cpuidle_lock);
@@ -129,15 +130,26 @@ static int cpuidle_add_device(struct sys
 		mutex_unlock(&cpuidle_lock);
 		return 0;
 	}
-	dev->status |=3D CPUIDLE_STATUS_DETECTED;
-	list_add(&dev->device_list, &cpuidle_detected_devices);
-	cpuidle_add_sysfs(sys_dev);
-	if (cpuidle_curr_driver)
-		cpuidle_attach_driver(dev);
-	if (cpuidle_curr_governor)
-		cpuidle_attach_governor(dev);
+	if (cpuidle_curr_driver) {
+		if (cpuidle_attach_driver(dev))
+			goto err_ret;
+	}
+
+	if (cpuidle_curr_governor) {
+		if (cpuidle_attach_governor(dev)) {
+			cpuidle_detach_driver(dev);
+			goto err_ret;
+		}
+	}
+
 	if (cpuidle_device_can_idle(dev))
 		cpuidle_install_idle_handler();
+
+	list_add(&dev->device_list, &cpuidle_detected_devices);
+	cpuidle_add_sysfs(sys_dev);
+	dev->status |=3D CPUIDLE_STATUS_DETECTED;
+
+err_ret:
 	mutex_unlock(&cpuidle_lock);
=20
 	return 0;
diff -puN drivers/cpuidle/driver.c~cpuidle-fix-boot-hang =
drivers/cpuidle/driver.c
--- a/drivers/cpuidle/driver.c~cpuidle-fix-boot-hang
+++ a/drivers/cpuidle/driver.c
@@ -37,8 +37,8 @@ int cpuidle_attach_driver(struct cpuidle
 	ret =3D cpuidle_curr_driver->init(dev);
 	if (ret) {
 		module_put(cpuidle_curr_driver->owner);
-		printk(KERN_ERR "cpuidle: driver %s failed to attach to cpu %d\n",
-			cpuidle_curr_driver->name, dev->cpu);
+		printk(KERN_INFO "cpuidle: driver %s failed to attach to "
+			"cpu %d\n", cpuidle_curr_driver->name, dev->cpu);
 	} else {
 		if (dev->status & CPUIDLE_STATUS_GOVERNOR_ATTACHED)
 			cpuidle_rescan_device(dev);
_

------_=_NextPart_001_01C77162.535DE751--
