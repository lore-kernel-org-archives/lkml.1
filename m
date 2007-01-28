Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbXA1MXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbXA1MXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 07:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXA1MXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 07:23:18 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:37205 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbXA1MXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 07:23:18 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: linux-usb-devel@lists.sourceforge.net
Subject: [patch] use __u32 rather than u32 in userspace ioctls in usbdevice_fs.h
Date: Sun, 28 Jan 2007 07:23:57 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_dXJvF+F1t7iE6ZQ"
Message-Id: <200701280723.57741.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_dXJvF+F1t7iE6ZQ
Content-Type: multipart/signed;
  boundary="nextPart3272878.t29gGdagJp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3272878.t29gGdagJp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

the trivial attached patch fixes ioctl defines in usbdevice_fs.h that are=20
exported to userspace to use __u32 rather than u32
=2Dmike

--nextPart3272878.t29gGdagJp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iQIVAwUARbyV3UFjO5/oN/WBAQIR0Q//W3KFFjReRdQ9nlTOptHRYiirkK7kqaTx
6bXUJQhCY198qct8bBnuzyEuKhwJvlHa+i7UgTaqbp4bJwIkxatiXoIxnM3bZl4g
txaoXmgXsMh+J3wAf/H2v+/3h2F6otKleuzLE2QHIuMv+fUnoYdZlTXiLOMPR9ds
wcX1NUnZj/HJRk+uoMZ+MzTvZYt+4+m5dVaIv2qNhaasGAl3WjhQ74kPAUqU/XJF
i1Yly7QsO03Wcbo5V2V8E8MLXKgRzhHxTNhTJVvQQ3B1nVkRFCiaMGcI8luNMlpc
UZYhwPt30DqYIp3vUCvLd43YXPU3vC74t98eAXXkcqOqyaPtT+qYi8dr9sNHtb3w
gL+dRVwAyl4K1pOFzb06OVmnD3APeeHMizQoelIaplbCofCssweEJ6nZpGjoIEKC
3aiQwCF7YaHGrGqcQAp7IgHnBYlFeV7/RCMBRGvTyxU+STMkB9AcH+Z5yFmyv2Ak
t+ms/E9Rm038KqaJ1LDkdSH6XVngLsgrlKfyIoalflf+3BbVVyfzD8lYEYdr1z+2
zodbMMrOZYwtT1In34ERHHBUWZC3/0jDHQbRlrodWPX6kKVzVL3vRR5DT2dpso50
p82G3u8qWGS5rwmyFvY4PIZ86oo+r5pn9GlpsdfzpCV6SDF+UqAkJ9/pkTAzg9TS
DruUXx8qN78=
=u5Bs
-----END PGP SIGNATURE-----

--nextPart3272878.t29gGdagJp--

--Boundary-00=_dXJvF+F1t7iE6ZQ
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-use-__-types-in-usbdevice-fs-header.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="linux-use-__-types-in-usbdevice-fs-header.patch"

Use __u32 rather than u32 in userspace ioctl defines.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>

--- a/include/linux/usbdevice_fs.h
+++ b/include/linux/usbdevice_fs.h
@@ -159,9 +159,9 @@ struct usbdevfs_ioctl32 {
 #define USBDEVFS_SUBMITURB32       _IOR('U', 10, struct usbdevfs_urb32)
 #define USBDEVFS_DISCARDURB        _IO('U', 11)
 #define USBDEVFS_REAPURB           _IOW('U', 12, void *)
-#define USBDEVFS_REAPURB32         _IOW('U', 12, u32)
+#define USBDEVFS_REAPURB32         _IOW('U', 12, __u32)
 #define USBDEVFS_REAPURBNDELAY     _IOW('U', 13, void *)
-#define USBDEVFS_REAPURBNDELAY32   _IOW('U', 13, u32)
+#define USBDEVFS_REAPURBNDELAY32   _IOW('U', 13, __u32)
 #define USBDEVFS_DISCSIGNAL        _IOR('U', 14, struct usbdevfs_disconnectsignal)
 #define USBDEVFS_CLAIMINTERFACE    _IOR('U', 15, unsigned int)
 #define USBDEVFS_RELEASEINTERFACE  _IOR('U', 16, unsigned int)

--Boundary-00=_dXJvF+F1t7iE6ZQ--
