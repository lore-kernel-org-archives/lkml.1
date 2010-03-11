Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0CKJDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:03:30 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:55418 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab0CKJDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:03:24 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] fs: fat: use hex_asc_lo/hex_asc_hi instead of custom  one
References: <1268261495-686-1-git-send-email-andy.shevchenko@gmail.com>
	<1268261495-686-2-git-send-email-andy.shevchenko@gmail.com>
	<1268261495-686-3-git-send-email-andy.shevchenko@gmail.com>
	<1268261495-686-4-git-send-email-andy.shevchenko@gmail.com>
	<1268261495-686-5-git-send-email-andy.shevchenko@gmail.com>
	<87aaufvk7w.fsf@devron.myhome.or.jp>
	<5ec8ebd51003102314n73723b11s10fa4c3564cce884@mail.gmail.com>
Date: Thu, 11 Mar 2010 18:03:20 +0900
In-Reply-To: <5ec8ebd51003102314n73723b11s10fa4c3564cce884@mail.gmail.com>
	(Andy Shevchenko's message of "Thu, 11 Mar 2010 09:14:04 +0200")
Message-ID: <87iq93s013.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko <andy.shevchenko@gmail.com> writes:

> On Thu, Mar 11, 2010 at 1:18 AM, OGAWA Hirofumi
> <hirofumi@mail.parknet.co.jp> wrote:
>>> +                             *op++ = hex_asc_hi(ec >> 8);
>>> +                             *op++ = hex_asc_lo(ec >> 8);
>>> +                             *op++ = hex_asc_hi(ec);
>>> +                             *op++ = hex_asc_lo(ec);
>> Why doesn't this use pack_hex_byte()?
> No specific reason, it could be so. Would you like me to change this?

Yes, please change it if you have no problem.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
