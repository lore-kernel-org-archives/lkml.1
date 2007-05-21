Return-Path: <linux-kernel-owner+w=401wt.eu-S1762768AbXEURKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762768AbXEURKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbXEURJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:09:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56510 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756684AbXEURJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:09:53 -0400
Date: Mon, 21 May 2007 10:04:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ken Chen <kenchen@google.com>
cc: Kay Sievers <kay.sievers@vrfy.org>, Ray Lee <ray-lk@madrabbit.org>,
       Al Viro <viro@ftp.linux.org.uk>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Uwe Bugla <uwe.bugla@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
In-Reply-To: <b040c32a0705210937x3d1b8ac6wb9c8089337f5c683@mail.gmail.com>
Message-ID: <alpine.LFD.0.98.0705211003590.3890@woody.linux-foundation.org>
References: <464F42F3.1080300@madrabbit.org>  <200705200845.43621.arvidjaar@mail.ru>
  <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com> 
 <20070520062816.GA4095@ftp.linux.org.uk>  <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
  <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com> 
 <2c0942db0705200910t777214efud489f4bc94433bf5@mail.gmail.com> 
 <1179677799.3311.5.camel@lov.localdomain> 
 <alpine.LFD.0.98.0705210908170.3890@woody.linux-foundation.org> 
 <b040c32a0705210927q24e2cd8fm9f4616941fccfdea@mail.gmail.com>
 <b040c32a0705210937x3d1b8ac6wb9c8089337f5c683@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 May 2007, Ken Chen wrote:
> 
> So I propose we do the following:
> 
> 1. have the module honor "max_loop" parameter and create that many
> device upfront on module load (max_loop will also be a hard max) iff
> user specify the parameter.
> 2. if max_loop is not specified, default create 8 loop device.  User
> can extent more loop device by create device node themselves and have
> kernel automatically instantiate loop device on-demand.
> 
> Is this acceptable?  Patch in a bit.

That sounds perfect.

		Linus
