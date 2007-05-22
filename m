Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbXEVALA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbXEVALA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbXEVAKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:10:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58874 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbXEVAKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:10:53 -0400
Date: Tue, 22 May 2007 01:10:38 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Ray Lee <ray-lk@madrabbit.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, Uwe Bugla <uwe.bugla@gmx.de>,
       Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Message-ID: <20070522001038.GC4095@ftp.linux.org.uk>
References: <20070519191751.E51233A23A2@muan.mtu.ru> <200705200124.13026.uwe.bugla@gmx.de> <200705200845.43621.arvidjaar@mail.ru> <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com> <20070520062816.GA4095@ftp.linux.org.uk> <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com> <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com> <2c0942db0705200910t777214efud489f4bc94433bf5@mail.gmail.com> <1179677799.3311.5.camel@lov.localdomain> <alpine.LFD.0.98.0705210908170.3890@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705210908170.3890@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 09:11:02AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 20 May 2007, Kay Sievers wrote:
> > 
> > Right, providing "preallocated" devices, 8 or the number given in
> > max_loop, sounds like the best option until the tools can handle that.
> 
> Yes. Can somebody who actually _uses_ loop send a tested patch, please?

FWIW, I do and I have tested it; what I did *not* do is using a testbox
with dynamic /dev for testing.  Mea culpa...

AFAICS, patch that went to akpm (preallocate max_loop instances) is OK.
