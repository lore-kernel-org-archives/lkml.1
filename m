Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbYEOHld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbYEOHld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYEOHkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:40:41 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:48099 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996AbYEOHkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:40:37 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 1/1] [usb/host]: use get/put_unaligned_* helpers to fix more potential unaligned issues.
Date: Thu, 15 May 2008 09:40:33 +0200
User-Agent: KMail/1.9.9
Cc: harvey.harrison@gmail.com, david-b@pacbell.net, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jie Zhang <jie.zhang@analog.com>
References: <1210832364-20012-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1210832364-20012-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200805150940.34516.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4F7flEB030164

Am Donnerstag 15 Mai 2008 08:19:24 schrieb Bryan Wu:> --- a/drivers/usb/host/uhci-hub.c> +++ b/drivers/usb/host/uhci-hub.c> @@ -253,7 +253,7 @@ static int uhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,> Â Â Â Â Â Â Â Â switch (typeReq) {> Â > Â Â Â Â Â Â Â Â case GetHubStatus:> -Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â *(__le32 *)buf = cpu_to_le32(0);> +Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â put_unaligned_le32(0, buf);
What is supposed to make all these changes a good idea?
	Regards		Oliver
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
