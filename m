Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYIJUSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYIJUSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYIJUSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:18:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58876
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbYIJUSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:18:31 -0400
Date: Wed, 10 Sep 2008 13:18:24 -0700 (PDT)
Message-Id: <20080910.131824.244309370.davem@davemloft.net>
To: kirill@shutemov.name
Cc: adobriyan@gmail.com, linux-kernel@vger.kernel.org, caulfie@redhat.com,
       teigland@redhat.com, dwmw2@infradead.org, akpm@linux-foundation.org
Subject: Re: [PATCH] include <linux/types.h> into linux/dlm_plock.h for
 __u* typedef
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080910131512.GH3757@localhost.localdomain>
References: <20080910125503.GG3757@localhost.localdomain>
	<20080910131158.GB3468@x200.localdomain>
	<20080910131512.GH3757@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m8AKIldq004138

From: "Kirill A. Shutemov" <kirill@shutemov.name>
Date: Wed, 10 Sep 2008 16:15:13 +0300

> $ make headers_install
> ...
> $ gcc usr/include/linux/dlm_plock.h
> usr/include/linux/dlm_plock.h:25: error: expected specifier-qualifier-list
> before â€˜__u32â€™

That's not how this file is used by real applications.
Anybody can cook up contrived cases like this.

Please show a real application or kernel compilation which breaks
because of the lack of types.h include here.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
