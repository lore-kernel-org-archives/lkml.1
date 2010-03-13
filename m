Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab0CMLJS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 06:09:18 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:58871 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997Ab0CMLJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 06:09:17 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCHv3] fs: fat: use pack_hex_byte() instead of custom one
References: <87aaueopt9.fsf@devron.myhome.or.jp>
	<1268468961-17033-1-git-send-email-andy.shevchenko@gmail.com>
Date: Sat, 13 Mar 2010 20:09:11 +0900
In-Reply-To: <1268468961-17033-1-git-send-email-andy.shevchenko@gmail.com>
	(Andy Shevchenko's message of "Sat, 13 Mar 2010 10:29:21 +0200")
Message-ID: <871vfobhrc.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko <andy.shevchenko@gmail.com> writes:

>  	const wchar_t *ip;
>  	wchar_t ec;
> -	unsigned char *op, nc;
> +	unsigned char *op;
>  	int charlen;
> -	int k;

Ah, thanks. I fixed this myself before commit.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
