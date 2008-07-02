Return-Path: <linux-kernel-owner+w=401wt.eu-S1762632AbYGBGdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762632AbYGBGdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 02:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbYGBGd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 02:33:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44177 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbYGBGd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 02:33:27 -0400
Date: Wed, 2 Jul 2008 08:33:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Donkey Ia <d0nk3y.ia@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: option of kernel config
In-Reply-To: <f2ae95280807011525t250ff74k2f20d876860f34e6@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0807020829000.20393@fbirervta.pbzchgretzou.qr>
References: <f2ae95280807011525t250ff74k2f20d876860f34e6@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-07-02 00:25, Donkey Ia wrote:

>Please, excuse me - probably it's a very stupid question for this
>place, but i need to know - could you tell me please, ﻿which exactly
>option (or maybe options) of kernel config calls ide hard disks
>/dev/sdX instead /dev/hdX?
>N?????r??y??????X??ǧv???)޺{.n??????{????zX????ܨ}???Ơz??j:+v???????zZ+???zf???h???~????????z??w?????????&?)ߢf???jǫy?m???A?a????0???????

There is no 'option', this is hardcoded in drivers/scsi/sd.c.

sd.c:           sprintf(gd->disk_name, "sd%c", 'a' + index % 26);
sd.c:           sprintf(gd->disk_name, "sd%c%c",
sd.c:           sprintf(gd->disk_name, "sd%c%c%c",

And you should not be changing this in that place.

Well I prefer libata over oldide since the scsi stack is loaded anyway.
