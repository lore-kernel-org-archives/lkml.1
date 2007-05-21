Return-Path: <linux-kernel-owner+w=401wt.eu-S1761124AbXEUNpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761124AbXEUNpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbXEUNo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:44:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52299 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbXEUNo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:44:56 -0400
Subject: Re: [3/5] 2.6.22-rc2: known regressions
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Francis Russell <francisrussell@btopenworld.com>,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       video4linux@list.redhat.com, Hans Verkuil <hverkuil@xs4all.nl>,
       Robert Fitzsimons <robfitz@273k.net>
In-Reply-To: <464F74D5.9080204@googlemail.com>
References: <464F6DC9.80805@googlemail.com>
	 <464F74D5.9080204@googlemail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 21 May 2007 07:44:04 -0300
Message-Id: <1179744244.4138.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Em Dom, 2007-05-20 às 00:06 +0200, Michal Piotrowski escreveu:

> V4L
> 
> Subject    : V4L ABI breakage
> References : http://lkml.org/lkml/2007/5/14/42
> Submitter  : Robert Fitzsimons <robfitz@273k.net>
> Caused-By  : Hans Verkuil <hverkuil@xs4all.nl>
>              Mauro Carvalho Chehab <mchehab@infradead.org>
>              commit 206ebaf32795cf1582b1e2ff2ec6a560c9e986b8
> Status     : Unknown

I was traveling abroad last week, without access to my devel
environment. Hans is currently working on a definitive fix for the
issue. His schedule is to have a proper solution until next week.

For now, it is better just to revert the bad changes. I've committed a
patch on my tree for that:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=15ac2d293b08b6975c6ca1a80eb839d4cb0dddbf

I'm currently running some tests on my environment with the fix patches
I currently have. I should send a pull request to Linus later today.

-- 
Cheers,
Mauro

