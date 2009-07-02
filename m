Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZGBR5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZGBR5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZGBR5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:57:20 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:44980 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbZGBR5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=KPnFh6k/Z9b1ESZQm0oM7HTWBo/WjOyk+Zl7JYQvqEq7Z87J/sPRITSgKJqugRTwtS
         76e4N9+0qTF9/ta9EG/NTRHOQaBTTEJlLUTcTTIi4WD00pA1kE9NgdNU/fUOlgFFid0H
         XraCkNR2XPEr729JR6A8SzVj977CjNdrLAYm0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>
Subject: Re: Staging: vt6656 ?
Date: Thu, 2 Jul 2009 19:45:49 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-next-20090617-09943-g5d77a4c; KDE/4.2.4; i686; ; )
Cc: Greg KH <gregkh@suse.de>, Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a4423d670906090331o6363fe56g34374967f21552e8@mail.gmail.com> <200906281759.46152.bzolnier@gmail.com> <20090628164716.GC9143@alittletooquiet.net>
In-Reply-To: <20090628164716.GC9143@alittletooquiet.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907021945.49926.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 28 June 2009 18:47:16 Forest Bond wrote:
> Hi,
> 
> On Sun, Jun 28, 2009 at 05:59:45PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 28 June 2009 15:57:31 Forest Bond wrote:
> > > Hi,
> > > 
> > > On Sun, Jun 28, 2009 at 03:43:12PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > 
> > > > Hi,
> > > > 
> > > > On Tuesday 09 June 2009 13:33:43 Forest Bond wrote:
> > > > > Hi,
> > > > > 
> > > > > On Tue, Jun 09, 2009 at 03:51:01AM -0700, Greg KH wrote:
> > > > > > On Tue, Jun 09, 2009 at 02:31:30PM +0400, Alexander Beregalov wrote:
> > > > > > > Hi Greg, Forest
> > > > > > > 
> > > > > > > Are you going to merge driver for VT6656 also?
> > > > > > 
> > > > > > If someone sends me some patches for it, sure, I will.
> > > > > 
> > > > > I have patches almost ready.  I'll send them by the end of next week at the
> > > > > latest.  Busy week here.
> > > > 
> > > > Did I miss the patch?  There are people already doing cleanups for VT6655
> > > > driver (which seems to share a great deal of code with VT6656 driver) so
> > > > it would greatly help to get VT6656 merged ASAP and merge the shared code
> > > > first to not duplicate efforts.
> > > > 
> > > > Also if you need some help with integrating the driver or hosting patches
> > > > in git tree at kernel.org before Greg picks them up [ he seems to be buried
> > > > alive by patches at the moment :) ] I'll be happy to help..
> > > 
> > > I sent it to Greg about two weeks ago.  I assume it is in his queue somewhere.
> > 
> > There seems to be a lot of stuff in his queue.. ;)
> > 
> > > Let me know if you think I ought to do something else with them.
> > 
> > Please re-post with cc:ing linux-kernel so people looking for them (i.e. me)
> > can pick them up from the list if needed (please also cc: lkml on all patches
> > in the future, thanks!).
> 
> Okay.  The first patch is quite large, so I will compress it.
> 
> > [ I'll later setup vt665x branch of my misc.git tree, merge your patches,
> >   merge all outstanding vt6655 patches from Alexander and investigate a bit
> >   more whether merge of vt665x drivers is feasible and what needs to be
> >   done if so.. ]
> 
> Good.

The temporary tree is here:

git://git.kernel.org:/pub/scm/linux/kernel/git/bart/misc.git vt665x

and I'll happily apply patches to it till Greg digs out from under the
overdue patch queues.. :)

I also took a look at both drivers and unification is certainly possible
and desirable, though not as easy as I had hoped initially..  here is the
sketch of preliminary TODO for vt6655:

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] vt6655: add TODO

Cc: Forest Bond <forest@alittletooquiet.net>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/vt6655/TODO |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: b/drivers/staging/vt6655/TODO
===================================================================
--- /dev/null
+++ b/drivers/staging/vt6655/TODO
@@ -0,0 +1,21 @@
+TODO:
+- remove __cplusplus ifdefs
+- prepare for merge with vt6656 driver:
+  - rename DEVICE_PRT() to DBG_PRT()
+  - share 80211*.h includes
+  - move code for channel mapping from card.c to channel.c
+  - split rf.c
+  - remove dead code
+  - abstract VT3253 chipset specific code
+- add common vt665x infrastructure
+- kill ttype.h
+- switch to use LIB80211
+- switch to use MAC80211
+- use kernel coding style
+- checkpatch.pl fixes
+- sparse fixes
+- integrate with drivers/net/wireless
+
+Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
+Forest Bond <forest@alittletooquiet.net> and Bartlomiej Zolnierkiewicz
+<bzolnier@gmail.com>.

and the corresponding one for vt6656:

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] vt6656: add TODO

Cc: Forest Bond <forest@alittletooquiet.net>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/vt6656/TODO |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: b/drivers/staging/vt6656/TODO
===================================================================
--- /dev/null
+++ b/drivers/staging/vt6656/TODO
@@ -0,0 +1,20 @@
+TODO:
+- remove __cplusplus ifdefs
+- remove kernel version compatibility wrappers
+- remove support for older wireless extensions
+- prepare for merge with vt6655 driver:
+  - remove PRINT_K() macro
+  - split rf.c
+  - abstract VT3184 chipset specific code
+- add common vt665x infrastructure
+- kill ttype.h
+- switch to use LIB80211
+- switch to use MAC80211
+- use kernel coding style
+- checkpatch.pl fixes
+- sparse fixes
+- integrate with drivers/net/wireless
+
+Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
+Forest Bond <forest@alittletooquiet.net> and Bartlomiej Zolnierkiewicz
+<bzolnier@gmail.com>.

> FYI, there is a known issue with the drivers as I've submitted them that causes
> lock-ups.  Please see the attached message for a suggested fix.

I think that all netdev_priv() changes should be reverted for now:

--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -100,6 +100,7 @@ static int          msglevel                =MSG_LEVEL_INFO;
 
 static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
 {
+    PSDevice apdev_priv;
 	struct net_device *dev = pDevice->dev;
 	int ret;
 
@@ -124,12 +125,13 @@ static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
 	       dev->name, pDevice->apdev->name);
 
 #else
-	pDevice->apdev = (struct net_device *)kmalloc(sizeof(struct net_device), GFP_KERNEL);
+    pDevice->apdev = (struct net_device *)kmalloc(sizeof(struct net_device), GFP_KERNEL);
 	if (pDevice->apdev == NULL)
 		return -ENOMEM;
 	memset(pDevice->apdev, 0, sizeof(struct net_device));
 
-	pDevice->apdev->priv = pDevice;
+    apdev_priv = netdev_priv(pDevice->apdev);
+    *apdev_priv = *pDevice;

We don't use alloc_netdev() for apdev allocation so by using netdev_priv()
later we are potentially accessing unrelated memory part.

--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -112,14 +112,17 @@ static void wpadev_setup(struct net_device *dev)
 
 static int wpa_init_wpadev(PSDevice pDevice)
 {
+    PSDevice wpadev_priv;
 	struct net_device *dev = pDevice->dev;
          int ret=0;
 
-	pDevice->wpadev = alloc_netdev(0, "vntwpa", wpadev_setup);
+	pDevice->wpadev = alloc_netdev(sizeof(PSDevice), "vntwpa", wpadev_setup);
 	if (pDevice->wpadev == NULL)
 		return -ENOMEM;
 
-	pDevice->wpadev->priv = pDevice;
+    wpadev_priv = netdev_priv(pDevice->wpadev);
+    *wpadev_priv = *pDevice;
+
 	memcpy(pDevice->wpadev->dev_addr, dev->dev_addr, U_ETHER_ADDR_LEN);
          pDevice->wpadev->base_addr = dev->base_addr;
 	pDevice->wpadev->irq = dev->irq;

This will copy the current state of pDevice to newly allocated private part
of ->apdev but later modifications to the original pDevice won't be seen if
we access it through netdev_priv(pDevice->apdev) instead of apdev->priv.

[ I don't know whether this is a problem currently but it looks suspicious. ]
