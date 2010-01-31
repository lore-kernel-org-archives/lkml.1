Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894Ab0AaSCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0AaSCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 13:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734Ab0AaSCm
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 13:02:42 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:7743 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0AaSCl convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-jbeulich@novell.com;4:1>);
	Sun, 31 Jan 2010 13:02:41 -0500
Message-Id: <4B65C5BE02000078000584B5@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Sun, 31 Jan 2010 18:02:38 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <hpa@zytor.com>
Cc: <mingo@elte.hu>, <jeremy@goop.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] x86: enlightenment for ticket spinlocks
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin"  01/31/10 2:42 AM >>>
>+ * EBX-EDX: "XenVMMXenVMM" signature, allowing positive identification
>+ *      of a Xen host.
>+ */
>+#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
>+#define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
>+#define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */
>
>I hope you know this spells "MMXenVMMXenV".  The ordering is ecx-edx-ebx
>(register numbers 1, 2, 3).

According to the documentation I have, the ordering is EBX-EDX-ECX,
so indeed the spelling would seem broken, but since this is an interface
header taken directly from Xen, it's got to be (and it works) that way.
Odd.

Jan

