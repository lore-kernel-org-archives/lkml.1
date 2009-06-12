Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbZFLUfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbZFLUfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 16:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbZFLUfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 16:35:22 -0400
Received: from Cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:62590 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848AbZFLUfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 16:35:22 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: hp-wmi: reading hddtemp results in ACPI errors
Date: Fri, 12 Jun 2009 22:35:21 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122235.22872.elendil@planet.nl>
X-OriginalArrivalTime: 12 Jun 2009 20:35:23.0418 (UTC) FILETIME=[4F92BFA0:01C9EB9D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my HP 2510p notebook I get five ACPI errors when the hp-wmi driver 
attempts to read hddtemp.

$ cat /sys/bus/platform/devices/hp-wmi/hddtemp
cat: /sys/bus/platform/devices/hp-wmi/hddtemp: Invalid argument

In dmesg this results in:
ACPI Exception (exoparg2-0445): AE_AML_PACKAGE_LIMIT, Index (000000002) is 
beyond end of object [20090320]
ACPI Error (psparse-0537): Method parse/execution failed [\_TZ_.C2FA] 
(Node ffff88007e042420), AE_AML_PACKAGE_LIMIT
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C2BB.C2D9] 
(Node ffff88007e040180), AE_AML_PACKAGE_LIMIT
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C2BB.C2D0] 
(Node ffff88007e01efc0), AE_AML_PACKAGE_LIMIT
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C2BB.WMAA] 
(Node ffff88007e040120), AE_AML_PACKAGE_LIMIT

Would it be possible to improve the driver to prevent these errors?


Somewhat related, the value of 'display' seems rather strange:
$ cat /sys/bus/platform/devices/hp-wmi/display
65795
Any idea if that's correct or not and what the meaning of that value is?

Cheers,
FJP
