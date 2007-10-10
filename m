Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbXJJOb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbXJJOb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 10:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXJJObt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 10:31:49 -0400
Received: from mail.exegy.com ([209.83.156.2]:1973 "EHLO mail.exegy.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753042AbXJJObs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 10:31:48 -0400
Thread-Index: AcgLSkoQ1BcRavw5ROaMAn5rnnBNWw==
X-Ninja-AntiSpoofing: spoofed
Message-ID: <470CE253.8040501@exegy.com>
Date: Wed, 10 Oct 2007 09:31:47 -0500
From: "Mr. Berkley Shands" <bshands@exegy.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "MegaRaid" <megaraidlinux@lsi.com>, <linux-kernel@vger.kernel.org>
Subject: 2.6.23 gotcha megaraid_sas missing
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Content-class: urn:content-classes:message
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4073
Importance: normal
X-OriginalArrivalTime: 10 Oct 2007 14:31:47.0708 (UTC) FILETIME=[4A0053C0:01C80B4A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

a new Kconfig entry was made CONFIG_SCSI_LOWLEVEL for 2.6.23 (since 
2.6.23-rc7)
Which turns OFF by default all the SCSI drivers, including MEGARAID_SAS.
This was not present previous to 2.6.23-rc9. As a result
a "make oldconfig" will nuke the scsi driver tree.

The default for this Kconfig
in drivers/scsi/Kconfig is wrong. it should default to on.

menuconfig SCSI_LOWLEVEL
        bool "SCSI low-level drivers"
        depends on SCSI!=n


berkley

-- 

// E. F. Berkley Shands, MSc//

** Exegy Inc.**

349 Marshall Road, Suite 100

St. Louis , MO  63119

Direct:  (314) 218-3600 X450

Cell:  (314) 303-2546

Office:  (314) 218-3600

Fax:  (314) 218-3601

 

The Usual Disclaimer follows...
 
This e-mail and any documents accompanying it may contain legally privileged and/or confidential information belonging to Exegy, Inc. Such information may be protected from disclosure by law. The information is intended for use by only the addressee. If you are not the intended recipient, you are hereby notified that any disclosure or use of the information is strictly prohibited. If you have received this e-mail in error, please immediately contact the sender by e-mail or phone regarding instructions for return or destruction and do not use or disclose the content to others.
