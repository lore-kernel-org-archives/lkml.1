Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0CKIKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:10:05 -0500
Received: from mail.perches.com ([173.55.12.10]:1643 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab0CKIKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:10:02 -0500
Subject: Re: [PATCH 4/5] fs: fat: use hex_asc_lo/hex_asc_hi instead of
 custom  one
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org
In-Reply-To: <5ec8ebd51003102359w277e6aadna483d44ee3ff856f@mail.gmail.com>
References: <1268261495-686-1-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-2-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-3-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-4-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-5-git-send-email-andy.shevchenko@gmail.com>
	 <87aaufvk7w.fsf@devron.myhome.or.jp>
	 <1268292100.11761.1.camel@Joe-Laptop.home>
	 <5ec8ebd51003102359w277e6aadna483d44ee3ff856f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 00:10:00 -0800
Message-ID: <1268295000.11761.12.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 09:59 +0200, Andy Shevchenko wrote:
> On Thu, Mar 11, 2010 at 9:21 AM, Joe Perches <joe@perches.com> wrote:
> >> > +                           *op++ = hex_asc_hi(ec >> 8);
> >> > +                           *op++ = hex_asc_lo(ec >> 8);
> >> > +                           *op++ = hex_asc_hi(ec);
> >> > +                           *op++ = hex_asc_lo(ec);
> >> Why doesn't this use pack_hex_byte()?
> > or snprintf
> sprintf looks like overkill here.

It's shorter and more intelligible though

	op += sprintf(op, ":%04x:%04x", etc) 

cheers, Joe


