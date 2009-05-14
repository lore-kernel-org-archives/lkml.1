Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbZENXCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbZENXCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760014AbZENWrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:47:42 -0400
Received: from vena.lwn.net ([206.168.112.25]:60721 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757875AbZENWrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:47:40 -0400
Date: Thu, 14 May 2009 16:47:37 -0600
From: Jake Edge <jake@lwn.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>, stable@kernel.org
Subject: Re: [patch] random: make get_random_int() more random
Message-ID: <20090514164737.6eaab4f0@chukar>
In-Reply-To: <20090506200954.GA21484@elte.hu>
References: <m1vdogbows.fsf@fess.ebiederm.org>
	<alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
	<20090505055011.GE31071@waste.org>
	<20090505063156.GA24504@elte.hu>
	<m14ow0ynjm.fsf@fess.ebiederm.org>
	<20090505195246.GC21973@elte.hu>
	<20090505202219.GL31071@waste.org>
	<20090506103034.GA25203@elte.hu>
	<20090506162543.GT31071@waste.org>
	<alpine.LFD.2.01.0905060942340.4983@localhost.localdomain>
	<20090506200954.GA21484@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009 22:09:54 +0200 Ingo Molnar wrote:

> Subject: random: make get_random_int() more random
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 5 May 2009 08:17:43 -0700 (PDT)
> 
> It's a really simple patch that basically just open-codes the current
> "secure_ip_id()" call, but when open-coding it we now use a _static_
> hashing area, so that it gets updated every time.

It seems like this should be queued up for stable, yes?  I just saw the
2.6.29.4 review patches go out, but this wasn't part of it ...

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
