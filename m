Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbZFMG7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbZFMG7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 02:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbZFMG7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 02:59:42 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:33553 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZFMG7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 02:59:42 -0400
In-Reply-To: <20090609191417.GC7181@uranus.ravnborg.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-arch@vger.kernel.org, linux-arch-owner@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 02/27] score: create boot/Makefile configs/spct6600_defconfig
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFCA60E253.39686277-ON482575D4.0025BC1E-482575D4.00266739@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Sat, 13 Jun 2009 14:55:00 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/13 ?? 02:55:01,
	Serialize complete at 2009/06/13 ?? 02:55:01
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5D70Q54011823

Hi Sam,

linux-arch-owner@vger.kernel.org Ğ´ÓÚ 2009-06-10 03:14:17:

> On Tue, Jun 09, 2009 at 02:23:27PM +0800, liqin.chen@sunplusct.com 
wrote:
> > >From 2beb0093ab93e3d7bbf6928fb28b620718afbb9f Mon Sep 17 00:00:00 
2001
> > From: Chen Liqin <liqin.chen@sunplusct.com>
> > Date: Tue, 9 Jun 2009 13:43:05 +0800
> > 
> > 
> > 
> > Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
> > ---
> >  arch/score/boot/Makefile              |   15 +
> >  arch/score/configs/spct6600_defconfig |  726 
> > +++++++++++++++++++++++++++++++++
> >  2 files changed, 741 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/score/boot/Makefile
> >  create mode 100644 arch/score/configs/spct6600_defconfig
> > 
> > diff --git a/arch/score/boot/Makefile b/arch/score/boot/Makefile
> > new file mode 100644
> > index 0000000..c3376b1
> > --- /dev/null
> > +++ b/arch/score/boot/Makefile
> > @@ -0,0 +1,15 @@
> > +#
> > +# arch/score/boot/Makefile
> > +#
> > +# This file is subject to the terms and conditions of the GNU General 

> > Public
> > +# License.  See the file "COPYING" in the main directory of this 
archive
> > +# for more details.
> > +#
> > +
> > +targets        := vmlinux.bin
> > +
> > +$(obj)/vmlinux.bin: vmlinux FORCE
> > +       $(call if_changed,objcopy)
> > +       @echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
> > +
> > +clean-kernel += vmlinux.bin
> I think you wanted to say: clean-files here?
> 

Thanks your comments, I have removed the unused lines and 
incorrect code from Kconfig and Makefile.

Best Regards
Liqin
--

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
