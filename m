Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754017AbYLQLNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYLQLNT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYLQLNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:13:04 -0500
Received: from exchtp08.via.com.tw ([61.66.243.7]:64853 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYLQLND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:13:03 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [Patch 2/3] via-sdmmc: via-sdmmc.c
Date: Wed, 17 Dec 2008 19:12:52 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB808521882@exchtp03.taipei.via.com.tw>
In-Reply-To: <200812161258.03787.oliver@neukum.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 2/3] via-sdmmc: via-sdmmc.c
Thread-Index: AclfdXKYkMn02YNST6m8D9SWM4G5YAAwtAdg
From: <JosephChan@via.com.tw>
To: <oliver@neukum.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Dec 2008 11:12:53.0663 (UTC) FILETIME=[680912F0:01C96038]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by imap1.linux-foundation.org id mBHBEbod020391

> > +
> > +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â addrbase = vcrdr_chip->pcictrl_mmiobase;
> > +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â writeb(PCI_CLK_375K, addrbase + PCISDCCLK_REG);
> > +
> > +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â via_reset_pcictrl(host);
> 
> This means a long delay with interrupts off. Is this really needed?
> 

We'll check this.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
