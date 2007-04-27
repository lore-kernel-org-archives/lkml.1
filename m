Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbXD0SGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbXD0SGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756976AbXD0SGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:06:37 -0400
Received: from deluge.CC.McGill.CA ([132.206.27.50]:37957 "EHLO
	deluge.cc.mcgill.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbXD0SGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:06:36 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 14:06:36 EDT
Subject: Build Failure in 2.6.21
From: David Ronis <ronis@ronispc.chem.mcgill.ca>
Reply-To: David.Ronis@mcgill.ca
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Chemistry Department, McGill University
Date: Fri, 27 Apr 2007 14:00:08 -0400
Message-Id: <1177696808.32236.12.camel@ronispc.chem.mcgill.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've just tried to upgrade the kernel from 2.6.19.9 to 2.6.21.  The
build dies in "make modules" at:

sound/pci/hda/patch_realtek.c:4174: error: array type has incomplete
element type
sound/pci/hda/patch_realtek.c:4175: error: field name not in record or
union initializer
sound/pci/hda/patch_realtek.c:4175: error: (near initialization for
'alc260_cfg_tbl')
sound/pci/hda/patch_realtek.c:4175: error: field name not in record or
union initializer
sound/pci/hda/patch_realtek.c:4175: error: (near initialization for
'alc260_cfg_tbl')

[lots more like the above].

sound/pci/hda/patch_realtek.c: In function 'patch_alc260':
sound/pci/hda/patch_realtek.c:4300: error: 'alc260_models' undeclared
(first use in this function)
sound/pci/hda/patch_realtek.c:4300: error: (Each undeclared identifier
is reported only once
sound/pci/hda/patch_realtek.c:4300: error: for each function it appears
in.)
make[3]: *** [sound/pci/hda/patch_realtek.o] Error 1
make[2]: *** [sound/pci/hda] Error 2
make[1]: *** [sound/pci] Error 2
make: *** [sound] Error 2

I'm on a i686, slackware-11.0 with gcc-4.1.2 box.  Things built fine on
another box (albeit with a different sound card and hence driver
options).

Please CC me on any reply.

David


