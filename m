Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbZAFDQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbZAFDQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 22:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZAFDQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 22:16:01 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:43050 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbZAFDQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 22:16:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qJ158s/wgzIERClMIsFkviJK5F6oCS/kLxtRt98VTmHxCcQNYZUfD7peNTXasMiJF1
         jFW063miWmB9XgXGrRw0/ysEMpl/e3E3ta4J6W2IOwcX6djhKsWxFHLfqJmuyf+cKO8X
         om3gsSU8H1XmAWJx2kygGc/mXWDrCC0FkS2u0=
Message-ID: <91b13c310901051915i38e05125tb89b3335922d274e@mail.gmail.com>
Date: Tue, 6 Jan 2009 11:15:58 +0800
From: "=?UTF-8?Q?Cheng_Renquan_(=E7=A8=8B=E4=BB=BB=E5=85=A8)?=" 
	<crquan@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [git pull] device-mapper patches for 2.6.29
Cc: "Alasdair G Kergon" <agk@redhat.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, "Jonathan Brassow" <jbrassow@redhat.com>,
       "Mikulas Patocka" <mpatocka@redhat.com>,
       "Milan Broz" <mbroz@redhat.com>, "Andi Kleen" <ak@suse.de>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com>,
       "Takahiro Yasui" <tyasui@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20081010125159.GK5098@agk.fab.redhat.com>
	 <20090105191824.GP5098@agk.fab.redhat.com>
	 <alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n063GLwM023529

2009/1/6 Linus Torvalds <torvalds@linux-foundation.org>:>>> On Mon, 5 Jan 2009, Alasdair G Kergon wrote:>>>> Please pull from:>>>>   master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git>>>> to get the following device-mapper patches for 2.6.29:>> Oh no, this is totally broken, and doesn't compile even with my fairly> minimal install:>>  drivers/md/dm-target.c: In function 'dm_unregister_target':>  drivers/md/dm-target.c:106: error: implicit declaration of function 'module_refcount'>> Not pulled.>>                Linus>
That's my fault, module_refcount can only be used ifCONFIG_MODULE_UNLOAD defined according to <linux/module.h>,
So now maybe we can add a null macro to module_refcount ifCONFIG_MODULE_UNLOAD undefined?
-- Cheng Renquan (ç¨‹ä»»å…¨), Shenzhen, ChinaPaula Poundstone  - "I don't have a bank account because I don't knowmy mother's maiden name."ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
