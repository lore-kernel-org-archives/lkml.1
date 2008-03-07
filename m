Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbYCGN5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbYCGN5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758716AbYCGN5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:57:23 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:44641 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460AbYCGN5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:57:22 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: headersinstall of kvm.h does not work
Date: Fri, 7 Mar 2008 14:57:18 +0100
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <200803071326.06682.borntraeger@de.ibm.com> <47D13BD1.30801@qumranet.com>
In-Reply-To: <47D13BD1.30801@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803071457.18735.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 7. März 2008 schrieb Avi Kivity:
> As I'm about to disappear for a week, consider a patch to remove the 
> config dependency and add asm-*/kvm.h pre-acked for mainline.  Maybe the 
> presence of those empty asm-*/kvm.h files will encourage further kvm 
> ports to *.

Something like the following for all architectures?

--- linux-2.6.orig/include/asm-alpha/Kbuild
+++ linux-2.6/include/asm-alpha/Kbuild
@@ -1,6 +1,7 @@
 include include/asm-generic/Kbuild.asm

 header-y += gentrap.h
+header-y += kvm.h
 header-y += regdef.h
 header-y += pal.h
 header-y += reg.h
Index: linux-2.6/include/asm-alpha/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-alpha/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_ALPHA_H
+#define __LINUX_KVM_ALPHA_H
+
+/* alpha does not support KVM */
+
+#endif
