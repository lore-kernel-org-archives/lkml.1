Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbXC3Vxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbXC3Vxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbXC3Vxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:53:37 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50943
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbXC3Vxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:53:36 -0400
From: Rob Landley <rob@landley.net>
To: linux-kernel@vger.kernel.org
Subject: Powerpc build unhappy in 2.6.20.4?
Date: Fri, 30 Mar 2007 17:53:26 -0400
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703301753.27379.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So doing:

  make ARCH=powerpc CROSS=powerpc-

Chugs along fine for a while, but then it ends with:

    MODPOST vmlinux
  ln: accessing `arch/powerpc/boot/zImage': No such file or directory
  make[1]: *** [arch/powerpc/boot/zImage] Error 1
  make: *** [zImage] Error 2

I.E. it builds vmlinux, then dies because there's no zImage, which it never 
tried to build...

Is there no working default "make" target for powerpc, or did I do something 
wrong?  Could this be a .config issue?

Rob
