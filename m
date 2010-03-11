Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0CKIAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:00:00 -0500
Received: from mail-ew0-f216.google.com ([209.85.219.216]:41554 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0CKH76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:59:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YoLy1ozq9NAI7inhEl9aE3UtRYO2vJeyOL04UJSST1VnaAtr5SqWZQuSneVueWiPOn
         wa2ZOHBlFwXVSX0BRkrOlf69WQ9FWSfEUA0A3mk1lst4t51Kerty4qSZbEXxNSxDOQ3g
         SSC8LZg6cCUPzbKgAuM4ygke1+HPxwHjA0fkY=
MIME-Version: 1.0
In-Reply-To: <1268292100.11761.1.camel@Joe-Laptop.home>
References: <1268261495-686-1-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-2-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-3-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-4-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-5-git-send-email-andy.shevchenko@gmail.com>
	 <87aaufvk7w.fsf@devron.myhome.or.jp>
	 <1268292100.11761.1.camel@Joe-Laptop.home>
Date: Thu, 11 Mar 2010 09:59:57 +0200
Message-ID: <5ec8ebd51003102359w277e6aadna483d44ee3ff856f@mail.gmail.com>
Subject: Re: [PATCH 4/5] fs: fat: use hex_asc_lo/hex_asc_hi instead of custom 
	one
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2B80DmE024617

On Thu, Mar 11, 2010 at 9:21 AM, Joe Perches <joe@perches.com> wrote:>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  *op++ = hex_asc_hi(ec >> 8);>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  *op++ = hex_asc_lo(ec >> 8);>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  *op++ = hex_asc_hi(ec);>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  *op++ = hex_asc_lo(ec);>> Why doesn't this use pack_hex_byte()?> or snprintfsprintf looks like overkill here.
-- With Best Regards,Andy Shevchenkoÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
