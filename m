Return-Path: <linux-kernel-owner+w=401wt.eu-S1761788AbZLLA5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761788AbZLLA5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbZLLA5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:57:03 -0500
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:42602 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756207AbZLLA5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:57:02 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Question: drivers/misc/hdpuftrs
Date: Fri, 11 Dec 2009 19:57:10 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB1116@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Question: drivers/misc/hdpuftrs
Thread-Index: Acp6xgkCZteRaiEzRmipluJjNFs8IA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Dec 2009 00:57:08.0422 (UTC) FILETIME=[07AAAE60:01CA7AC6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Are the drivers in drivers/misc/hdpuftrs dead?

I can't locate anywhere to enable CONFIG_HDPU_FEATURES.  Also, both
hdpu_cpustate.c and hdpu_nexus.c register as platform drivers but I
can't find any users in the mainline tree.

Both drivers seem kind of... ugly...

hdpu_cpustate.c does a lock_kernel() in the open file_operation.  Then
does a spin_lock() when checking if the open is O_EXCL.

I'm no expert on locking but the lock_kernel() seems unnecessary.

Regards,
Hartley
