Return-Path: <linux-kernel-owner+w=401wt.eu-S932264AbXF1WEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbXF1WEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763343AbXF1WEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:04:13 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:36835 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761387AbXF1WEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:04:12 -0400
Message-ID: <46842F7B.1010105@gmail.com>
Date: Fri, 29 Jun 2007 00:00:27 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: William D Waddington <william.waddington@beezmo.com>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, Al Boldi <a1426z@gawab.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Please release a stable kernel Linux 3.0
References: <fa.ZV8hYZHQHqzfx1dgOFeEVFRogSg@ifi.uio.no>	<oor483d2nqn6ae728com1v7v56g0ksotov@4ax.com>	<4683983E.5020103@aitel.hist.no>	<4683D3B0.1040708@beezmo.com> <20070628173051.4a3422c0@the-village.bc.nu>
In-Reply-To: <20070628173051.4a3422c0@the-village.bc.nu>
Content-Type: multipart/mixed;
 boundary="------------060406030205040301060207"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060406030205040301060207
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 06/28/2007 06:30 PM, Alan Cox wrote:

> Public domain is GPL compatible.

Would you happen to have an opinion on the attached? I don't so much need it 
or anything but I thought about submitting this once when I was working on 
some stuff locally. I didn't since I was expecting arguments that public 
domain is not so much a license, and how it becomes GPL anyway, ...

Stating that code which one intends to be in the public domain has "GPL and 
additional rights" is a bit of a travesty though.

Signed-off-by: Rene Herman <rene.herman@gmail.com>

Rene.

--------------060406030205040301060207
Content-Type: text/plain;
 name="public_domain.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="public_domain.diff"

diff --git a/include/linux/license.h b/include/linux/license.h
index decdbf4..1176471 100644
--- a/include/linux/license.h
+++ b/include/linux/license.h
@@ -8,7 +8,8 @@ static inline int license_is_gpl_compatible(const char *license)
 		|| strcmp(license, "GPL and additional rights") == 0
 		|| strcmp(license, "Dual BSD/GPL") == 0
 		|| strcmp(license, "Dual MIT/GPL") == 0
-		|| strcmp(license, "Dual MPL/GPL") == 0);
+		|| strcmp(license, "Dual MPL/GPL") == 0
+		|| strcmp(license, "Public Domain") == 0);
 }
 
 #endif
diff --git a/include/linux/module.h b/include/linux/module.h
index e6e0f86..2ecacf8 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -107,6 +107,7 @@ extern struct module __this_module;
  *					 or MIT license choice]
  *	"Dual MPL/GPL"			[GNU Public License v2
  *					 or Mozilla license choice]
+ *	"Public Domain"			[Public domain products]
  *
  * The following other idents are available
  *

--------------060406030205040301060207--
