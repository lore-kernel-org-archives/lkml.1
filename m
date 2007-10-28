Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbXJ1Rcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbXJ1Rcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXJ1Rcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:32:39 -0400
Received: from smtp803.mail.ird.yahoo.com ([217.146.188.63]:39491 "HELO
	smtp803.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752381AbXJ1Rci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:32:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=btinternet.com;
  h=Received:X-YMail-OSG:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding;
  b=EiIF9Ljr6e/Vc7ZcARLluxzgrYqIzX3N3dxHNWt/QVbmb6ExjKytRrmkfh/ph/rvqYOpUqKlksMgnnjDbIjVhoB1h/hRkrzSskr8vQTOZAv9J4Hi38G4zr4kwJiWLCFcNK6FC76FjAGsJjbXjjl4VAPjOLQ+C3nLUgttGaH9rLQ=  ;
X-YMail-OSG: _JEcKKIVM1lcii.8x2isA2Ts0sp2y13AtjszXWrBuJ0U7Xu7yFwGVfGX9uggD22zVH3T0lczvmJjtQKfc6XI5Dv5JoGep6ZM0A--
Date: Sun, 28 Oct 2007 17:26:13 +0000
From: Bradley Smith <bradjsmith@btinternet.com>
To: linux-kernel@vger.kernel.org, dz@debian.org
Subject: [PATCH 2/2] I8K: Adds i8k driver to the x86_64 Kconfig
Message-ID: <20071028172613.236cac1b@debian.hob>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bradley Smith <bradjsmith@btinternet.com>

Adds i8k driver to the x86_64 Kconfig.

Signed-off-by: Bradley Smith <bradjsmith@btinternet.com>

---

Only applies on kernels >= 2.6.24.
Depends on "[PATCH 1/2] I8K: Allow i8k driver to be built on x86_64 systems"

--- linux-2.6/arch/x86/Kconfig.x86_64.orig	2007-10-28 14:04:13.000000000 +0000
+++ linux-2.6/arch/x86/Kconfig.x86_64	2007-10-28 13:59:06.000000000 +0000
@@ -224,6 +224,26 @@ config X86_GOOD_APIC
 	bool
 	default y
 
+config I8K
+	tristate "Dell laptop support"
+	---help---
+	  This adds a driver to safely access the System Management Mode
+	  of the CPU on the Dell Inspiron 8000. The System Management Mode
+	  is used to read cpu temperature and cooling fan status and to
+	  control the fans on the I8K portables.
+
+	  This driver has been tested only on the Inspiron 8000 but it may
+	  also work with other Dell laptops. You can force loading on other
+	  models by passing the parameter `force=1' to the module. Use at
+	  your own risk.
+
+	  For information on utilities to make use of this driver see the
+	  I8K Linux utilities web site at:
+	  <http://people.debian.org/~dz/i8k/>
+
+	  Say Y if you intend to run this kernel on a Dell Inspiron 8000.
+	  Say N otherwise.
+
 config MICROCODE
 	tristate "/dev/cpu/microcode - Intel CPU microcode support"
 	select FW_LOADER
