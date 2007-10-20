Return-Path: <linux-kernel-owner+w=401wt.eu-S1764250AbXJTNCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764250AbXJTNCV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 09:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbXJTNCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 09:02:11 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:55731 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbXJTNCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 09:02:09 -0400
Message-ID: <4719FC34.5010909@linux.vnet.ibm.com>
Date: Sat, 20 Oct 2007 18:31:40 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Kconfig.instrumentation not available on i386
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index f6e44fc..9e8a74f 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -1258,6 +1258,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/i386/Kconfig.debug"
 
 source "security/Kconfig"
