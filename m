Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbYG3JP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbYG3JP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbYG3JPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:15:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:41389 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbYG3JPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=A2EcN93AxIkC0OeYH/cd16dAMutSRQKghBwmK1O3/YEBzOMSz9WHnGV81EDSqktHJA
         lCws6i0E7gnveltxt1c0FcvmlfI178dTUPwR7pRn1b6Cz+rP9tzifsbxnWwOQFVWXB04
         Jm/Xw6WnvDlltl2IRQY0BdtOaR8U+P4ph6UOE=
Message-ID: <82faac5b0807300215j6cd9d938t7058080a65ffff74@mail.gmail.com>
Date: Wed, 30 Jul 2008 19:15:46 +1000
From: "Darren Jenkins" <darrenrjenkins@gmail.com>
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH] fs/fat/dir.c fix resource leak
Cc: "kernel Janitors" <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87d4kwalh1.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <1217289813.9367.9.camel@localhost.localdomain>
	 <87hca8alz6.fsf@devron.myhome.or.jp>
	 <87d4kwalh1.fsf@devron.myhome.or.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6U9Fxfq032602

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> BTW, email address of Signed-off-by line is typo?
Yes, my mistake.
ï»¿ï»¿ï»¿ï»¿Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>


> I noticed this is false positive. bufname is not used anymore, and> fat_parse_long() never returns error after allocating unicode.
Yes you are right about unicode, I should of picked that up.
bufname is not used anymore ? I'm not sure what you mean? are youtalking about an external tree ?

Darren Jenkinsÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
