Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbXKPSAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbXKPSAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757144AbXKPSAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:00:10 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:50072 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbXKPSAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:00:09 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: Suspend/Resume/Hibernation - bisecting or bug-logs?
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2007 21:00:02 +0300
References: <20071116161420.e2c57ff6.Kristoffer.Ericson@Gmail.com>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20071116180006.0029C87EE9C@smtp06.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristoffer Ericson wrote:

> Greetings,
> 
> Ive been following your discussion and documentation efforts concerning pm
> in the kernel. This has in the past been a gray area which was hard to
> find information about so kudos.
> 
> I maintain 2 handheld platforms that would benefit greatly from
> implementing proper pm (mainly suspend) but Im having problems bugtracking
> it. Currently the system tries to suspend but fails somewhere and then
> tries to resume (which fails). The end result however is that Im unable to
> see anything (bugmessages...) since the video driver gets deactivated by
> pm.
> 
> My question is this: Is bisecting (turning off device support in kernel
> until it works) the best approach when bugtracking pm suspend? Or is there
> any other logging system that I can use?
> 

Good question. I could use advice too :)

Bisecting is good only if you have known good and known bad versions. From
your description it sounds like it has never worked - so bisecting won't
help. Also sometimes bisecting hits way too large commit (this happened to
me when ACPI replaced mutex with spinlock).

