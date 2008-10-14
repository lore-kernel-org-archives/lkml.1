Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbYJNHVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbYJNHVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbYJNHVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:21:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:8081 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbYJNHVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NBXrJfy+/ty4lu9uPrT2BizT4kNs8p/ey7KDfc09ajUtuFpBBw4hKVZJrD2zku8WsB
         oYN3iFyyeCZOQ7R0vyGhQelPIpeZfvCG9cfn/3ZS2Ig7SD4bQh3wGxTZ8eDRagUZWYRz
         GbFvA9Lq5FEgxh+7bu/jT+q5B19Nx1Ek8ukDU=
Message-ID: <742b1fb30810140021h565520c3oa102005a539d6a1f@mail.gmail.com>
Date: Tue, 14 Oct 2008 09:21:31 +0200
From: "Patrizio Bassi" <patrizio.bassi@gmail.com>
To: "=?UTF-8?Q?Simon_Holm_Th=C3=B8gersen?=" <odie@cs.aau.dk>
Subject: Re: 2.6.27 gspca driver fails with Trust WB-1400T
Cc: "Kernel," <linux-kernel@vger.kernel.org>
In-Reply-To: <1223932867.21717.8.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <48F3AD5A.2080504@gmail.com> <1223932867.21717.8.camel@odie.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9E7Lkdq019164

2008/10/13 Simon Holm ThÃ¸gersen <odie@cs.aau.dk>>> man, 13 10 2008 kl. 22:19 +0200, skrev Patrizio Bassi:> > Hi> >> > i have a Trust 1400T perfectly working on 2.6.26 using external module> > (media-video/gspcav1-20071224 is the gentoo version so it's that day> > snapshot.)> >> > Upgrading to 2.6.27 kernel, using integrated kernel driver> >> Does the following text explain it (imagine the text being at the front> page of [2])?>> "Historically, there has been a number of different projects ([1], ...),> providing v4l drivers outside of the mainline Linux kernel. If you are> migrating from drivers by such projects, you might need to know a few> things. The drivers provided by this project do not do various color> conversion routines in the kernel, but in a userspace library that we> also provide [3].>> This means that programs that use v4l and v4l2 must either be>  - able to do the necessary color conversion themselves,>  - link against our userspace library that provides these>   conversions, or>  - be loaded using an appropriately set LD_PRELOAD environment>   variable.">> [1] http://mxhaard.free.fr/> [2] http://linuxtv.org/v4lwiki/index.php/Main_Page> [3] http://linuxtv.org/hg/~hgoede/v4l-dvb>>> Simon Holm ThÃ¸gersen>
ok, it sounds i need to read some wikis...i'll come back to you wheni'm done with the result
--Patrizio Bassiwww.patriziobassi.itÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
