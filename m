Return-Path: <linux-kernel-owner+w=401wt.eu-S934626AbXGRSdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626AbXGRSdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbXGRSd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:33:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53642 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830AbXGRSd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:33:28 -0400
Date: Wed, 18 Jul 2007 20:33:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.22-git* regression: Kconfig prompts without help text
In-Reply-To: <469E5629.4020409@oracle.com>
Message-ID: <Pine.LNX.4.64.0707182031130.5385@fbirervta.pbzchgretzou.qr>
References: <469BBDAD.2010908@s5r6.in-berlin.de>
 <Pine.LNX.4.64.0707181634100.5385@fbirervta.pbzchgretzou.qr>
 <20070718094119.4a26ae03.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0707181916410.5385@fbirervta.pbzchgretzou.qr>
 <20070718103456.cf32bf78.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0707181954190.5385@fbirervta.pbzchgretzou.qr>
 <469E5629.4020409@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 18 2007 11:04, Randy Dunlap wrote:
>> > I have no idea where it came from.  (not me)
>> 
>> It was akpm:
>> http://linux.bkbits.net:8080/linux-2.6/Documentation/CodingStyle?PAGE=diffs&REV=1.5
>
> I think that would only make sense if "---help---" is used (like you did)
> instead of the plain "help" string.
>
> In the case of "---help---", it's OK with me not to be indented by 2 more
> spaces.

===

kconf also accepts "---help---" besides the usual "help" keyword.
If it is used, I think we can omit the extra spaces, because the
dashes are visible enough a sash.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 Documentation/CodingStyle |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux-2.6.23/Documentation/CodingStyle
===================================================================
--- linux-2.6.23.orig/Documentation/CodingStyle
+++ linux-2.6.23/Documentation/CodingStyle
@@ -511,17 +511,16 @@ remember: "indent" is not a fix for bad 
 
 For all of the Kconfig* configuration files throughout the source tree,
 the indentation is somewhat different.  Lines under a "config" definition
-are indented with one tab, while help text is indented an additional two
-spaces.  Example:
+are indented with one tab. Example:
 
 config AUDIT
 	bool "Auditing support"
 	depends on NET
-	help
-	  Enable auditing infrastructure that can be used with another
-	  kernel subsystem, such as SELinux (which requires this for
-	  logging of avc messages output).  Does not do system-call
-	  auditing without CONFIG_AUDITSYSCALL.
+	---help---
+	Enable auditing infrastructure that can be used with another
+	kernel subsystem, such as SELinux (which requires this for
+	logging of avc messages output).  Does not do system-call
+	auditing without CONFIG_AUDITSYSCALL.
 
 Features that might still be considered unstable should be defined as
 dependent on "EXPERIMENTAL":
