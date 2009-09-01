Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZIAHLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZIAHLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZIAHLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:11:53 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:59043
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbZIAHLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:11:52 -0400
X-Greylist: delayed 1106 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Sep 2009 03:11:52 EDT
In-Reply-To: <200908310956.33802.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [GIT PULL, v4] S+core architecture (arch/score) support
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF4CFE082A.22292F01-ON48257624.0024EFF9-48257624.0025CD0B@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 1 Sep 2009 14:45:28 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/09/01 ?? 02:45:30,
	Serialize complete at 2009/09/01 ?? 02:45:30
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n817C916031764

Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2009-08-31 17:56:33:

> On Monday 31 August 2009 07:48:33 liqin.chen@sunplusct.com wrote:
> > Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2009-08-27 22:00:37:
> 
> __NR_ipc definitely should not be defined, it is a multiplexer
> for other system calls that have their own number, e.g. msgctl
> and semop. Look at e.g. how parisc does it in glibc.
> 

Ok, we do it as parisc does

> 
> Do you have a patch against the glibc git tree for score so I can look
> at what needs to be done? None of the changes should be specific to
> score after all, ideally it should all work without any glibc changes,
> though I realize that we are not there yet.
> 

I will send the patch to you soon.

liqin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
