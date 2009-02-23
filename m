Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbZBWUCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbZBWUCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbZBWUCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:02:16 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:47676 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbZBWUCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:02:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=PLc56Eb5TTKlZjw0SSuQReo4av5bJFNQQHdomEyZ5jQldBqopy7PElE9YTeWlV2mag
         08hphtHltS4MKnFBpgQvvdJPJZVYivEIcp5GmID1ttGTA9xzAgErFuBbiEZZpXIFDrLm
         WWKQEGpfRTqXgC/HV8eYL8o5IZuzDv07b+V3Q=
Message-Id: <20090223200227.158233243@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 23 Feb 2009 22:57:00 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: heukelum@fastmail.fm, Jeremy Fitzhardinge <jeremy@xensource.com>,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 4/6] x86: entry_64.S - add missing ENDPROC
References: <20090223195656.512422509@openvz.org>
Content-Disposition: inline; filename=x86-add-missed-end-native_usergs_sysret64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

native_usergs_sysret64 is described as

	extern void native_usergs_sysret64(void)

so lets add ENDPROC here

CC: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/entry_64.S |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6.git/arch/x86/kernel/entry_64.S
@@ -188,6 +188,7 @@ return_to_handler:
 ENTRY(native_usergs_sysret64)
 	swapgs
 	sysretq
+ENDPROC(native_usergs_sysret64)
 #endif /* CONFIG_PARAVIRT */
 
 

