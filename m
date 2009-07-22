Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbZGVDrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbZGVDrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbZGVDrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:47:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42707
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755933AbZGVDq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:46:59 -0400
Date: Tue, 21 Jul 2009 20:47:04 -0700 (PDT)
Message-Id: <20090721.204704.123531717.davem@davemloft.net>
To: petkovbb@googlemail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ide-tape: fix handling of postponed rqs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1247910917-5237-4-git-send-email-petkovbb@gmail.com>
References: <1247910917-5237-1-git-send-email-petkovbb@gmail.com>
	<1247910917-5237-4-git-send-email-petkovbb@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6M3lLJ7013824

From: Borislav Petkov <petkovbb@googlemail.com>
Date: Sat, 18 Jul 2009 11:55:17 +0200

> ide-tape used to hit
> 
> [   58.614854] ide-tape: ht0: BUG: Two DSC requests queued!
> 
> due to the fact that another rq was being issued while the driver was
> waiting for DSC to get set for the device executing ATAPI commands which
> set the DSC to 1 to indicate completion.
> 
> Here's a sample output of that case:

Do you even compile the code you send me and look to see if there are
any new warnings generated or anything like that?

drivers/ide/ide-tape.c: In function â€˜ide_tape_stall_queueâ€™:
drivers/ide/ide-tape.c:379: warning: unused variable â€˜rqâ€™

Fix this.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
