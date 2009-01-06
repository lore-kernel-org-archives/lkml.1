Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbZAFDdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbZAFDdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 22:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZAFDcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 22:32:54 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:2641 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZAFDcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 22:32:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=A/f2B4sMwOCuwFslNi5HOlweDdj1ezniubqXIoPzC5YH3g2ygNnE2vg/qHK2Os72OJ
         bvCgQeZ6Ti33+tVqGZ1nG8t14iZQ9hCL/KWJsGhk7RubVKCVE+Jx+8iyW2DHrS/eSn0R
         7awDO/wUlPn9swr5C4isLeHUB2a+7TnZ6gC1E=
Message-ID: <91b13c310901051932p1343f9eei1db5534e6e10d238@mail.gmail.com>
Date: Tue, 6 Jan 2009 11:32:51 +0800
From: "=?UTF-8?Q?Cheng_Renquan_(=E7=A8=8B=E4=BB=BB=E5=85=A8)?=" 
	<crquan@gmail.com>
To: "Alasdair G Kergon" <agk@redhat.com>
Subject: Re: [git pull] device-mapper patches for 2.6.29
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, "Jonathan Brassow" <jbrassow@redhat.com>,
       "Mikulas Patocka" <mpatocka@redhat.com>,
       "Milan Broz" <mbroz@redhat.com>, "Andi Kleen" <ak@suse.de>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com>,
       "Takahiro Yasui" <tyasui@redhat.com>
In-Reply-To: <20090106032118.GC3512@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20081010125159.GK5098@agk.fab.redhat.com>
	 <20090105191824.GP5098@agk.fab.redhat.com>
	 <alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
	 <91b13c310901051915i38e05125tb89b3335922d274e@mail.gmail.com>
	 <20090106032118.GC3512@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n063XAwM023602

On Tue, Jan 6, 2009 at 11:21 AM, Alasdair G Kergon <agk@redhat.com> wrote:> On Tue, Jan 06, 2009 at 11:15:58AM +0800, Cheng Renquan (ç¨‹ä»»å…¨) wrote:>> So now maybe we can add a null macro to module_refcount if>> CONFIG_MODULE_UNLOAD undefined?>> Do we even need the test at all?
So you mean add "#ifdef CONFIG_MODULE_UNLOAD ..." to dm-target.c? Ican do that, but I really don't know a better solution withoutconditional compiling?
>> Alasdair> --> agk@redhat.com
-- Cheng Renquan, Shenzhen, ChinaEddie Izzard  - "I grew up in Europe, where the history comes from."ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
