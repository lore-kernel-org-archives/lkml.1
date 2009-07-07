Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbZGGUhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbZGGUhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758363AbZGGUh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:37:28 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:56070 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851AbZGGUh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:37:26 -0400
Message-ID: <4A53B202.9080505@davidnewall.com>
Date: Wed, 08 Jul 2009 06:07:22 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: Denys Vlasenko <vda.linux@googlemail.com>,
       Albert ARIBAUD <albert.aribaud@free.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
References: <20090703015554.GB5880@cr0.nay.redhat.com>	 <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>	 <4A4DDD54.9030206@free.fr>	 <200907070643.56394.vda.linux@googlemail.com> <412e6f7f0907070045o6a17fb10x557108ffde0da11@mail.gmail.com>
In-Reply-To: <412e6f7f0907070045o6a17fb10x557108ffde0da11@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao wrote:
>  mkfifo(name);
>  open(name, O_RDWR);
>  unlink(name);
>
> Is it a trick?

This does beg the question, why is it necessary to "extend" pipe() in
this way?
