Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbYLYUh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbYLYUh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 15:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYLYUhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 15:37:48 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:36605 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752021AbYLYUhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 15:37:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=X3bw5Ye9zNprcNRuRMN4theCLegXgRGQ2IvznkhNDr6QhwLThBCmWIkN1qLGwx6jJWcv0zmVqSswOcsStk6DrePNJmcigaQPHv2Nl1jP/VD4iA7t04EZyuGAk/aQkXOJPhRiaK9mgxhcq58B4T6req3OeTppUJfSxyblSN4VXqI=  ;
X-YMail-OSG: HQGCMPYVM1m4aRKN0XhVwBiSqQWTOUL7OVBXmQri8Rr8.xK7Qzpxc7AXEpJN3CBUEPdw.X1N4FbMeDNO6ZjYqs5RQQkHPIEBQlYku.S7bmiT.g.QmHtrOyG6r2TK8Wtt12XfwrcvLoQKMVpKzvu7ztkf6LSukTVNSqyQuLB26gSuTd45RrkGKqk0I2vcXULBmMu6_bOYDtEy439TLnetbbZ.XJPcOpVlP7a.Gg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: gregkh@suse.de
Subject: Re: [PATCH] musb: fix DaVinci build again
Date: Thu, 25 Dec 2008 12:37:44 -0800
User-Agent: KMail/1.9.10
Cc: davinci-linux-open-source@linux.davincidsp.com, me@felipebalbi.com,
       linux-usb@vger.kernel.org, felipe.balbi@nokia.com,
       linux-kernel@vger.kernel.org,
       Kevin Hilman <khilman@deeprootsystems.com>
References: <200812072341.50012.sshtylyov@ru.mvista.com> <20081224022757.GA10240@frodo> <200812231952.16171.david-b@pacbell.net>
In-Reply-To: <200812231952.16171.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812251237.44532.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, I suggest you just use the appended patch to *REPLACE* the
patch now in your gregkh-04-usb queue:

   usb-musb-build-fixes-for-davinci.patch

Net effect of including this plus the other patches in
that queue is to achieve what the original 2.6.27-rc(3?)
build fix patch would have done, if it were merged right.

- Dave

===========
From: Kevin Hilman <khilman@deeprootsystems.com>

 - update includes after asm/arch --> mach headers move

[ dbrownell@users.sourceforge.net: just fix mismerge of my 2.6.27-rc patch ]

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/davinci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -32,9 +32,9 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 
-#include <asm/arch/hardware.h>
-#include <asm/arch/memory.h>
-#include <asm/arch/gpio.h>
+#include <mach/hardware.h>
+#include <mach/memory.h>
+
 #include <asm/mach-types.h>
 
 #include "musb_core.h"
