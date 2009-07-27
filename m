Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbZG0TlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbZG0TlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZG0TlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:41:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbZG0TlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:41:14 -0400
Date: Mon, 27 Jul 2009 12:40:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ray Lee <ray-lk@madrabbit.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <87skgikjr8.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.01.0907271237250.25224@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87bpn7mzli.fsf@devron.myhome.or.jp> <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> <873a8iqqgv.fsf@devron.myhome.or.jp> <20090727142303.41096bf5@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp>
 <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, OGAWA Hirofumi wrote:
> 
> If I read that part of emacs correctly, it seems to be assuming the data
> was already sent to master side if the child process was exited.

That sounds like a rather obvious assumption.

Aren't pty's flushing the data at flush() time? Which should be happening 
when the child process exits and closes the pty slave.

So at what point do we just admit that the commit that caused all this was 
a buggy pile of sh*t and just revert it?

		Linus
