Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbZG0MqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbZG0MqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 08:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZG0MqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 08:46:11 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:35738 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZG0MqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 08:46:09 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<200907241721.45943.rjw@sisk.pl>
	<20090724164058.21a054e6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
	<87ws5xjo2x.fsf@devron.myhome.or.jp>
	<20090725150510.35e8854d@lxorguk.ukuu.org.uk>
	<87ab2sx15g.fsf@devron.myhome.or.jp>
	<20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
Date: Mon, 27 Jul 2009 21:46:07 +0900
In-Reply-To: <873a8iqqgv.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Mon, 27 Jul 2009 21:07:28 +0900")
Message-ID: <87skgipa40.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

>> +	spin_lock_irqsave(&pair->buf.lock, flags);
>> +	pair->packet = 0;
>
> I worried "pair->packet = 0" when I'm thinking this. I guess it would be
> changed more early than before. Is it ok?

Ah, maybe, this is ok. Because n_tty_read() checks it, so, I guess there
is no big difference with before change.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
