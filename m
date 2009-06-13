Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbZFMHEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbZFMHEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 03:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760777AbZFMHET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 03:04:19 -0400
Received: from 60-248-182-106.HINET-IP.hinet.net ([60.248.182.106]:44513 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760871AbZFMHES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 03:04:18 -0400
In-Reply-To: <20090609191826.GD7181@uranus.ravnborg.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 19/27] score: create kernel files asm-offsets.c entry.S head.S
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFC173E4DC.A0C85216-ON482575D4.00260559-482575D4.0026BA67@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Sat, 13 Jun 2009 14:58:33 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/13 ?? 02:58:33,
	Serialize complete at 2009/06/13 ?? 02:58:33
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5D75Y54011873

Sam Ravnborg <sam@ravnborg.org> Ğ´ÓÚ 2009-06-10 03:18:26:

> > new file mode 100644
> > index 0000000..a7432c1
> > --- /dev/null
> > +++ b/arch/score/kernel/head.S
> > @@ -0,0 +1,70 @@
> > +#include <asm/asm-offsets.h>
> > +
> > +       .extern start_kernel
> > +       .global init_thread_union
> > +       .global kernelsp
> > +
> > +       .section .init.text, "ax"
> 
> Please use section definitions from include/linux/init.h.
> __INIT in this case.
> 
> Other architectures uses __HEAD so they have full control
> on where to add this code in the final image.
> 

Thanks Sam, I used macro define in linux/init.h instead of 
the code in all .S files.

Best Regards
Liqin
--
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
