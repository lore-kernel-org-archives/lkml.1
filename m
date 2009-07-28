Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbZG1QQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbZG1QQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbZG1QQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:16:56 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:33855 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbZG1QQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:16:56 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
	<20090727222010.1a5efb7b@lxorguk.ukuu.org.uk>
	<87r5w19xsb.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.01.0907280843050.3186@localhost.localdomain>
Date: Wed, 29 Jul 2009 01:16:51 +0900
In-Reply-To: <alpine.LFD.2.01.0907280843050.3186@localhost.localdomain> (Linus
	Torvalds's message of "Tue, 28 Jul 2009 08:48:02 -0700 (PDT)")
Message-ID: <87y6q8aiks.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>> n_tty_read() checks the pending buffer and consume it before
>> input_available_p().
>
> Why not move this _inside_ "input_available_p()"? There are only two 
> call-sites, and strictly speaking they both want it.

The only reason for me is this is just quick hack.

Yes, I guess the input_available_p() is preferable place than my patch.
I'm still not checking the related path etc. deeply though.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
