Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYAXAH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYAXAH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYAXAHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:07:20 -0500
Received: from gw.goop.org ([64.81.55.164]:44772 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbYAXAHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:07:19 -0500
Message-ID: <4797D6B5.9070405@goop.org>
Date: Wed, 23 Jan 2008 16:07:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 2.6.24-rcX] xen: disable vcpu_info placement for now
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have been several reports of Xen guest domains locking up when
using vcpu_info structure placement.  Disable it for now.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/xen/enlighten.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -95,7 +95,7 @@ struct shared_info *HYPERVISOR_shared_in
  *
  * 0: not available, 1: available
  */
-static int have_vcpu_info_placement = 1;
+static int have_vcpu_info_placement = 0;
 
 static void __init xen_vcpu_setup(int cpu)
 {


