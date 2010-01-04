Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472Ab0ADWNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0ADWNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914Ab0ADWNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:13:52 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:52397 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab0ADWNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:13:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Jg8zOQr/13YGsywBV4hbrYwl5rEi8aIEccHvv/N90vvJclrxX3M93d3x0wGipdxag2
         hTyd2ReG+CaqUbnRAAoLYumBquq/dgwRk8GPH+eTt/Br3AY0KTBgkUSEw+9A0P2qcw+U
         qSMhkgMZ9fPAHojQQr7BvgQbSRmy4GT72zGCM=
Date: Mon, 4 Jan 2010 23:13:45 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH/resend] Document awk requirements
Message-ID: <20100104221345.GA7897@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gnu awk is required for generating generating
arch/x86/lib/inat-tables.c:

 GEN     arch/x86/lib/inat-tables.c
 Error: Your awk doesn't support charactor-class.

mawk doesn't work anymore.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
---
Hum, who is in charge of the documentation?
Masami can you push it?

 Documentation/Changes |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/Changes b/Documentation/Changes
index f08b313..abec6f2 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -50,6 +50,7 @@ o  udev                   081                     # udevinfo -V
 o  grub                   0.93                    # grub --version
 o  mcelog		  0.6
 o  iptables               1.4.1                   # iptables -V
+o  Gnu awk                3.1.5                   # awk --version
 
 
 Kernel compilation
