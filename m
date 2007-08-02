Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbXHBMtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbXHBMtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbXHBMtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:49:13 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:59972 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbXHBMtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:49:12 -0400
Message-ID: <46B1D26E.2010508@free.fr>
Date: Thu, 02 Aug 2007 14:47:42 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org
CC: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net
Subject: PROFILE_NMI kernel config symbol
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The -rt patch includes the following update:

Index: linux/arch/i386/oprofile/Kconfig
===================================================================
--- linux.orig/arch/i386/oprofile/Kconfig
+++ linux/arch/i386/oprofile/Kconfig
@@ -15,3 +15,6 @@ config OPROFILE

  	  If unsure, say N.

+config PROFILE_NMI
+	bool
+	default y


What is the purpose of the PROFILE_NMI config symbol?
(It does not seem to be used anywhere else in the -rt patch.)

Regards.
