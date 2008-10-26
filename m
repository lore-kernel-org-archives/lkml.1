Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYJZBG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYJZBG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 21:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbYJZBGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 21:06:49 -0400
Received: from cpsmtpo-eml06.KPNXCHANGE.COM ([213.75.38.155]:6884 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292AbYJZBGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 21:06:47 -0400
From: Frans Pop <elendil@planet.nl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: kbuild maintainer news [Was: kbuild fixes for -rc1]
Date: Sun, 26 Oct 2008 03:06:43 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
References: <20081025211107.GA20417@uranus.ravnborg.org> <20081025211107.GA20417@uranus.ravnborg.org> <20081025215959.GA27617@uranus.ravnborg.org>
In-reply-To: <20081025215959.GA27617@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kK8AJ0rEcDNQD8m"
Message-Id: <200810260206.44969.elendil@planet.nl>
X-OriginalArrivalTime: 26 Oct 2008 01:06:45.0228 (UTC) FILETIME=[1D474AC0:01C93707]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_kK8AJ0rEcDNQD8m
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sam Ravnborg wrote:
> So if you have any pending kbuild patches around please
> resend them to me with a cc: to at least linux-kbuild.

A similar patch to what you just pushed for rpm's to avoid package 
installation problems due to firmware is waiting also for deb-pkg.
Please push the patch in [1] to Linus and stable. Original mail attached.

Cheers,
FJP

[1] http://lkml.org/lkml/2008/9/13/102



--Boundary-00=_kK8AJ0rEcDNQD8m
Content-Type: message/rfc822;
  name="forwarded message"
Content-Transfer-Encoding: 7bit
Content-Description: Jonathan McDowell <noodles@earth.li>: Re: [PATCH] Fixup deb-pkg target to generate separate firmware deb.
Content-Disposition: inline

Return-path: <noodles@earth.li>
X-Spam-Checker-Version: SpamAssassin 3.2.3 (2007-08-08) on elrond.fjphome.nl
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.5 tests=AWL,BAYES_00,
	RCVD_IN_DNSWL_LOW,RDNS_NONE autolearn=ham version=3.2.3
Envelope-to: fjp@localhost
Delivery-date: Sat, 13 Sep 2008 18:20:02 +0200
Received: from localhost
	([127.0.0.1] helo=elrond.fjphome.nl ident=fjp)
	by elrond.fjphome.nl with esmtp (Exim 4.63)
	(envelope-from <noodles@earth.li>)
	id 1KeXqs-0004jK-B4
	for fjp@localhost; Sat, 13 Sep 2008 18:20:02 +0200
Received: from pop.wxs.nl [195.121.6.53]
	by elrond.fjphome.nl with POP3 (fetchmail-6.3.6)
	for <fjp@localhost> (single-drop); Sat, 13 Sep 2008 18:20:02 +0200 (CEST)
Received: from hpsmtp-eml01.kpnxchange.com ([10.94.77.135]) by CPEXBE-EML18.kpnsp.local with Microsoft SMTPSVC(6.0.3790.1830);
	 Sat, 13 Sep 2008 18:08:31 +0200
Received: from the.earth.li ([217.147.81.2]) by hpsmtp-eml01.kpnxchange.com with Microsoft SMTPSVC(6.0.3790.3959);
	 Sat, 13 Sep 2008 18:08:31 +0200
Received: from noodles by the.earth.li with local (Exim 4.63)
	(envelope-from <noodles@earth.li>)
	id 1KeXfj-000140-GK; Sat, 13 Sep 2008 17:08:31 +0100
Date: Sat, 13 Sep 2008 17:08:31 +0100
From: Jonathan McDowell <noodles@earth.li>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org,
 linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fixup deb-pkg target to generate separate firmware deb.
Message-ID: <20080913160831.GE30927@earth.li>
References: <20080912112042.GX30927@earth.li> <200809131035.18477.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809131035.18477.elendil@planet.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 13 Sep 2008 16:08:31.0656 (UTC) FILETIME=[F775C280:01C915BA]
X-Length: 4638
X-UID: 618

[Adding linux-kbuild as that seems to be the closest to a maintainer for
scripts/package/]

On Sat, Sep 13, 2008 at 10:35:18AM +0200, Frans Pop wrote:
> On Friday 12 September 2008, Jonathan McDowell wrote:
> > The below is a simplistic fix for "make deb-pkg"; it splits the
> > firmware out to a linux-firmware-image package and adds an
> > (unversioned) Suggests to the linux package for this firmware.
> >
> > Frans, does this solve your problem in an acceptable manner?
> 
> Yes it does. Thanks for the patch Jonathan.
> Tested both with kernel configs that result in firmware and that do not 
> result in firmware.
> 
> A few minor nitpicks below.

Ta, I've fixed both the indents. I've also changed the firmware package
to be arch: all.

> > Signed-Off-By: Jonathan McDowell <noodles@earth.li>
> Acked-by: Frans Pop <elendil@planet.nl>
 
-----
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index ba6bf5d..1264b8e 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -15,15 +15,18 @@ set -e
 version=$KERNELRELEASE
 revision=`cat .version`
 tmpdir="$objtree/debian/tmp"
+fwdir="$objtree/debian/fwtmp"
 packagename=linux-$version
+fwpackagename=linux-firmware-image
 
 if [ "$ARCH" == "um" ] ; then
 	packagename=user-mode-linux-$version
 fi
 
 # Setup the directory structure
-rm -rf "$tmpdir"
+rm -rf "$tmpdir" "$fwdir"
 mkdir -p "$tmpdir/DEBIAN" "$tmpdir/lib" "$tmpdir/boot"
+mkdir -p "$fwdir/DEBIAN" "$fwdir/lib"
 if [ "$ARCH" == "um" ] ; then
 	mkdir -p "$tmpdir/usr/lib/uml/modules/$version" "$tmpdir/usr/share/doc/$packagename" "$tmpdir/usr/bin"
 fi
@@ -107,6 +110,7 @@ Standards-Version: 3.6.1
 
 Package: $packagename
 Provides: kernel-image-$version, linux-image-$version
+Suggests: $fwpackagename
 Architecture: any
 Description: Linux kernel, version $version
  This package contains the Linux kernel, modules and corresponding other
@@ -118,8 +122,24 @@ fi
 chown -R root:root "$tmpdir"
 chmod -R go-w "$tmpdir"
 
+# Do we have firmware? Move it out of the way and build it into a package.
+if [ -e "$tmpdir/lib/firmware" ]; then
+	mv "$tmpdir/lib/firmware" "$fwdir/lib/"
+
+	cat <<EOF >> debian/control
+
+Package: $fwpackagename
+Architecture: all
+Description: Linux kernel firmware, version $version
+ This package contains firmware from the Linux kernel, version $version
+EOF
+
+	dpkg-gencontrol -isp -p$fwpackagename -P"$fwdir"
+	dpkg --build "$fwdir" ..
+fi
+
 # Perform the final magic
-dpkg-gencontrol -isp
+dpkg-gencontrol -isp -p$packagename
 dpkg --build "$tmpdir" ..
 
 exit 0
-----

J.

-- 
"Just because I'll spend 4 hours automating a task that takes 4 minutes
by hand doesn't mean I'm not lazy." -- Mike Sphar, asr


--Boundary-00=_kK8AJ0rEcDNQD8m--
