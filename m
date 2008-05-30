Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYE3OXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYE3OXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 10:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYE3OXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 10:23:39 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:40879 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYE3OXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 10:23:38 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] kaweth: use request_firmware()
Date: Fri, 30 May 2008 15:55:57 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, Michael Zappe <zapman@interlan.net>,
       Stephane Alnet <stephane@u-picardie.fr>,
       Brad Hards <bhards@bigpond.net.au>
References: <1211708969@pmac.infradead.org> <1212070841.26088.28.camel@shinybook.infradead.org>
In-Reply-To: <1212070841.26088.28.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200805301555.59327.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4UEP7Hl031174

Am Donnerstag, 29. Mai 2008 16:20:41 schrieb David Woodhouse:> Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â if ((result = kaweth_download_firmware(kaweth,> -Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â  Â  Â  Â kaweth_trigger_code_fix,> -Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â  Â  Â  Â len_kaweth_trigger_code_fix,> +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â  Â  Â  Â "kaweth/trigger_code_fix.bin",
We don't put hirarchy policy into drivers.
	Regards		Oliver
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
