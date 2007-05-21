Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbXEUQTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbXEUQTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbXEUQSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:18:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbXEUQSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:18:53 -0400
Date: Mon, 21 May 2007 09:11:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Ray Lee <ray-lk@madrabbit.org>, Al Viro <viro@ftp.linux.org.uk>,
       Andrey Borzenkov <arvidjaar@mail.ru>, Uwe Bugla <uwe.bugla@gmx.de>,
       Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
In-Reply-To: <1179677799.3311.5.camel@lov.localdomain>
Message-ID: <alpine.LFD.0.98.0705210908170.3890@woody.linux-foundation.org>
References: <464F42F3.1080300@madrabbit.org>  <20070519191751.E51233A23A2@muan.mtu.ru>
  <200705200124.13026.uwe.bugla@gmx.de>  <200705200845.43621.arvidjaar@mail.ru>
  <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com> 
 <20070520062816.GA4095@ftp.linux.org.uk>  <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
  <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com> 
 <2c0942db0705200910t777214efud489f4bc94433bf5@mail.gmail.com>
 <1179677799.3311.5.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 20 May 2007, Kay Sievers wrote:
> 
> Right, providing "preallocated" devices, 8 or the number given in
> max_loop, sounds like the best option until the tools can handle that.

Yes. Can somebody who actually _uses_ loop send a tested patch, please?

We're not going to break existing user space over something idiotic like 
this. Not acceptable. 

The alternative is to just revert all the loop.c patches. Which I'll do 
unless somebody sends me a tested fix - because as a non-loop user myself, 
I don't have much choice. I assume it is 

   commit 73285082 "remove artificial software max_loop limit"

that introduced the new behaviour. Ken?

		Linus
