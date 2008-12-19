Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbYLSAeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbYLSAeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYLSAd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:33:58 -0500
Received: from kroah.org ([198.145.64.141]:57570 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750789AbYLSAd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:33:57 -0500
Subject: patch uio-make-uio_info-s-name-and-version-const.patch added to gregkh-2.6 tree
To: sfr@canb.auug.org.au, gregkh@suse.de, hjk@linutronix.de,
       linux-kernel@vger.kernel.org, w.sang@pengutronix.de
From: <gregkh@suse.de>
Date: Thu, 18 Dec 2008 16:29:10 -0800
In-Reply-To: <20081212104420.GA3084@local>
Message-ID: <1229646550799@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: uio: make uio_info's name and version const

to my gregkh-2.6 tree.  Its filename is

    uio-make-uio_info-s-name-and-version-const.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From hjk@linutronix.de  Thu Dec 18 15:52:51 2008
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 12 Dec 2008 11:44:21 +0100
Subject: uio: make uio_info's name and version const
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>, Wolfram Sang <w.sang@pengutronix.de>
Message-ID: <20081212104420.GA3084@local>
Content-Disposition: inline

From: Stephen Rothwell <sfr@canb.auug.org.au>

These are only ever assigned constant strings and never modified.

This was noticed because Wolfram Sang needed to cast the result of
of_get_property() in order to assign it to the name field of a struct
uio_info.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/DocBook/uio-howto.tmpl |    4 ++--
 include/linux/uio_driver.h           |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -393,12 +393,12 @@ offset = N * getpagesize();
 
 <itemizedlist>
 <listitem><para>
-<varname>char *name</varname>: Required. The name of your driver as
+<varname>const char *name</varname>: Required. The name of your driver as
 it will appear in sysfs. I recommend using the name of your module for this.
 </para></listitem>
 
 <listitem><para>
-<varname>char *version</varname>: Required. This string appears in
+<varname>const char *version</varname>: Required. This string appears in
 <filename>/sys/class/uio/uioX/version</filename>.
 </para></listitem>
 
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -76,8 +76,8 @@ struct uio_device;
  */
 struct uio_info {
 	struct uio_device	*uio_dev;
-	char			*name;
-	char			*version;
+	const char		*name;
+	const char		*version;
 	struct uio_mem		mem[MAX_UIO_MAPS];
 	struct uio_port		port[MAX_UIO_PORT_REGIONS];
 	long			irq;


Patches currently in gregkh-2.6 which might be from sfr@canb.auug.org.au are

usb/usb-don-t-use-__module_param_call.patch
driver-core/uio-make-uio_info-s-name-and-version-const.patch
staging/staging-go7007-convert-driver-to-use-video_ioctl2.patch
staging/staging-comedi-fix-build-if-config_proc_fs-is-not-set.patch
staging/staging-meilhaus-fix-__symbol_get-problems.patch
