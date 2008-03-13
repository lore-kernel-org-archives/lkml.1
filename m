Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYCMRC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYCMRC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYCMRCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:02:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24653 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbYCMRCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:02:48 -0400
Date: Thu, 13 Mar 2008 10:02:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh <greg@kroah.com>
Subject: Re: linux-next: Tree for March 13 (PCI patch)
Message-Id: <20080313100235.89cf2508.randy.dunlap@oracle.com>
In-Reply-To: <20080313173506.2613be02.sfr@canb.auug.org.au>
References: <20080313173506.2613be02.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 17:35:06 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (tar balls at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

---

From: Randy Dunlap <randy.dunlap@oracle.com>

access.c uses udelay() so needs to #include delay.h.

next-20080313/drivers/pci/access.c:167: error: implicit declaration of function 'udelay'
make[3]: *** [drivers/pci/access.o] Error 1
make[2]: *** [drivers/pci] Error 2
make[1]: *** [drivers] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [sub-make] Error 2

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pci/access.c |    1 +
 1 file changed, 1 insertion(+)

--- next-20080313.orig/drivers/pci/access.c
+++ next-20080313/drivers/pci/access.c
@@ -1,3 +1,4 @@
+#include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <linux/sched.h>
