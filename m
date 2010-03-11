Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0CKHOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:14:10 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:64862 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab0CKHOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:14:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M0LYlHNp3spd93HLrAtlFg+6Zq0+J3fvk24rjOCr7ZwscaXRDgHXQHLDxSvDBeA3GQ
         lG3WCXkMSmm4c70/aClfBWJ5ni6Uofbw905+O71AR8ieiyYevDtxTJGFCsdcDCcpg1/L
         S7OQxcDlpOO/nobi6PJVX4XHpXHc2qnzp54qE=
MIME-Version: 1.0
In-Reply-To: <87aaufvk7w.fsf@devron.myhome.or.jp>
References: <1268261495-686-1-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-2-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-3-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-4-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-5-git-send-email-andy.shevchenko@gmail.com>
	 <87aaufvk7w.fsf@devron.myhome.or.jp>
Date: Thu, 11 Mar 2010 09:14:04 +0200
Message-ID: <5ec8ebd51003102314n73723b11s10fa4c3564cce884@mail.gmail.com>
Subject: Re: [PATCH 4/5] fs: fat: use hex_asc_lo/hex_asc_hi instead of custom 
	one
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2B7EFmE023877

On Thu, Mar 11, 2010 at 1:18 AM, OGAWA Hirofumi<hirofumi@mail.parknet.co.jp> wrote:>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  *op++ = hex_asc_hi(ec >> 8);>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  *op++ = hex_asc_lo(ec >> 8);>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  *op++ = hex_asc_hi(ec);>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  *op++ = hex_asc_lo(ec);> Why doesn't this use pack_hex_byte()?No specific reason, it could be so. Would you like me to change this?
-- With Best Regards,Andy Shevchenkoÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
