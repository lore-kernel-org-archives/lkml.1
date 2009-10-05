Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZJEPcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZJEPcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZJEPcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:32:11 -0400
Received: from e70.imt-systems.com ([89.146.219.60]:42177 "EHLO
	e70.imt-systems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbZJEPcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:32:10 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 11:32:10 EDT
From: "Morten P.D. Stevens" <mstevens@imt-systems.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 5 Oct 2009 17:22:35 +0200
Subject: Linux 2.6.32-rc3 build failure
Thread-Topic: Linux 2.6.32-rc3 build failure
Thread-Index: AcpFz6pd+T7CB3EUQ7KxE2nrhvxfZg==
Message-ID: <B44ED17A15FFBB4BB0CC8A3FDC9E96C401BCB185@EXCH-CCR-10.corp.imt-systems.com>
Accept-Language: de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: AXEJ BxJW CJpk ECB/ ERCQ E3Iu FXEv FyIW HXby Ho4e H83f
 IqX/ J9Sc K1Za Lbc0
 MO8s;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{6A045CFE-018B-4D9E-A831-FFB67A6778D9};bQBzAHQAZQB2AGUAbgBzAEAAaQBtAHQALQBzAHkAcwB0AGUAbQBzAC4AYwBvAG0A;Mon,
 05 Oct 2009 15:22:35
 GMT;TABpAG4AdQB4ACAAMgAuADYALgAzADIALQByAGMAMwAgAGIAdQBpAGwAZAAgAGYAYQBpAGwAdQByAGUA
x-cr-puzzleid: {6A045CFE-018B-4D9E-A831-FFB67A6778D9}
acceptlanguage: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the drivers tree failed with this error:

  CC [M]  drivers/media/video/uvc/uvc_ctrl.o
  CC [M]  drivers/media/video/uvc/uvc_status.o
drivers/media/video/uvc/uvc_ctrl.c: In function âuvc_ctrl_set_zoomâ:
drivers/media/video/uvc/uvc_ctrl.c:351: warning: comparison of distinct pointer types lacks a cast
  CC [M]  drivers/media/video/uvc/uvc_isight.o
  CC [M]  drivers/media/video/zoran/zoran_card.o
  CC [M]  drivers/media/video/zoran/videocodec.o
  CC [M]  drivers/media/video/zoran/zr36050.o
  CC [M]  drivers/media/video/zoran/zr36016.o
  CC [M]  drivers/media/video/zoran/zr36060.o
  LD [M]  drivers/media/video/uvc/uvcvideo.o
  LD [M]  drivers/media/video/zoran/zr36067.o
make[1]: *** [drivers] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.32-rc3'
make: *** [debian/stamp/build/kernel] Error 2

--

Morten
