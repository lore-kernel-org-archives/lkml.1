Return-Path: <linux-kernel-owner+w=401wt.eu-S1761528AbXEUJml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761528AbXEUJml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761269AbXEUJm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:42:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:63811 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761132AbXEUJm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=EhUExz/pjZknusyqBcCLcoQDJD4t1dTDPNE34jCovqdLdpC9s9iPrKD0S1QHpzo/6XJFFgv7irhbdsxFjLPweL6XdiNESyuefP5asbFBzuNdCVCDHnV3Kuwa/YG5q+/yI+4pfl7danUPefhcl3XqA73pvB7ubNK5yURd9hOUT3M=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][Trivial] Documentation: sysrq, description of 'h' slightly inaccurate
Date: Mon, 21 May 2007 11:42:10 +0200
User-Agent: KMail/1.9.6
Cc: trivial@kernel.org, vulpyne@vulpyne.net, crutcher+kernel@datastacks.com,
       jesper.juhl@gmail.com
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705211142.13555.jesper.juhl@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In Documentation/sysrq.txt, the description of 'h' says that any key not 
listed *above* will generate help. That's obviously not true since all the 
keys listed below 'h' will do what they are described to do, not display 
help. So change the text so that it says that any key not listed in the 
table will generate help, which is what really happens.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Documentation/sysrq.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
index ba328f2..865b271 100644
--- a/Documentation/sysrq.txt
+++ b/Documentation/sysrq.txt
@@ -1,6 +1,6 @@
 Linux Magic System Request Key Hacks
 Documentation for sysrq.c
-Last update: 2007-MAR-14
+Last update: 2007-MAY-21
 
 *  What is the magic SysRq key?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -78,7 +78,7 @@ On all -  write a character to /proc/sysrq-trigger.  e.g.:
 'g'	- Used by kgdb on ppc and sh platforms.
 
 'h'     - Will display help (actually any other key than those listed
-          above will display help. but 'h' is easy to remember :-)
+          here will display help. but 'h' is easy to remember :-)
 
 'i'     - Send a SIGKILL to all processes, except for init.
 

