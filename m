Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbYJaNJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbYJaNJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYJaNIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:08:52 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:60664 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYJaNIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=BYNFe1rAe1JFVkQCKtjr02qfH3kyrEWOMEzK1njw2wdUniY0Tm5ZJ9C8CQNPpwsUI+
         /ROqpaJKTtLp0E/pHjsNG4KIW0FJMX6+YfHm6ZYc2DxgfhoUAwlV6tXgte+tRaRetF2S
         jltLuPDAC270hXBKThAMyzZDMItIGQOmX8LPo=
Message-ID: <cf70f0210810310608x37f8e3dcu3ab0023891fcb339@mail.gmail.com>
Date: Fri, 31 Oct 2008 18:38:49 +0530
From: "Shivdas Gujare" <shivdas.tech@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Diff between Linux-2.6.27-omap1-dirty and Linux-2.6.27-omap1 ?
Cc: beagleboard@googlegroups.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am working on testing Linux-2.6.27 omap kernel on beagle board.

I cloned kernel from
git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git

and checked out to tag v2.6.27-omap1, I loaded kernel on beagle board,
and was able to boot properly like....

OMAP3 beagleboard.org # bootm 0x80300000
## Booting kernel from Legacy Image at 80300000 ...
   Image Name:   Linux-2.6.27-omap1
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    1614320 Bytes =  1.5 MB
   Load Address: 80008000
   Entry Point:  80008000
   Verifying Checksum ... OK
   Loading Kernel Image ... OK
OK

Now, I done some operations, like checkout to master, checkout to
v2.6.26-omap1 and v2.6.25-omap1, loaded corresponding uImages to
beagle board
and was able to boot board every time.

After this, I again checkout to v2.6.27-omap1, compiled and loaded
uImage to beagleboard
But this time I am not able to boot the board.
and Got the message like

OMAP3 beagleboard.org # bootm 0x80300000
## Booting kernel from Legacy Image at 80300000 ...
   Image Name:   Linux-2.6.27-omap1-dirty
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    1669176 Bytes =  1.6 MB
   Load Address: 80008000
   Entry Point:  80008000
   Verifying Checksum ... OK
   Loading Kernel Image ... OK
OK

Starting kernel ...

Uncompressing Linux...........................................................................................................
done, booting the kernel.

and it, stucks at here..

Here, the only difference I observed is "Image Name:
Linux-2.6.27-omap1" and "Image Name:   Linux-2.6.27-omap1-dirty",
where uImage with second Image name is not booting.

I think, I have done something wrong here, while compilation and checkout.

I just want to know in what cases "-dirty" is appended to linux kernel
Image Names or anything I done wrong?

Thanks for your Helps.

Regards,
Shivdas
