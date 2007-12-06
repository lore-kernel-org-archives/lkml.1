Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbXLFPBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbXLFPBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXLFPBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:01:44 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:43766 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbXLFPBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:01:43 -0500
Date: Thu, 6 Dec 2007 16:01:42 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Gabriele Gorla <gorlik@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Patch submission question [not in the FAQ]
In-Reply-To: <602863.12913.qm@web53712.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0712061559210.19266@fbirervta.pbzchgretzou.qr>
References: <602863.12913.qm@web53712.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 5 2007 03:36, Gabriele Gorla wrote:
>@@ -392,6 +392,8 @@ typedef struct TAG_TW_Passthru
>        unsigned char padding[12];
> } TW_Passthru;
> 
>+#pragma pack()
>+
> typedef struct TAG_TW_Device_Extension {
>        u32                     base_addr;
>        unsigned long
>*alignment_virtual_address[TW_Q_LENGTH];
>@@ -430,6 +432,4 @@ typedef struct
>TAG_TW_Device_Extension {
>        wait_queue_head_t       ioctl_wqueue;
> } TW_Device_Extension;
> 
>-#pragma pack()
>-

Hmpf. Can't you __attribute__((packed))-ify the structs rather
than use #pragma?
