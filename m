Return-Path: <linux-kernel-owner+w=401wt.eu-S932206AbXFAREw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbXFAREw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760976AbXFAREf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:04:35 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760788AbXFAREd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:04:33 -0400
Date: Fri, 1 Jun 2007 10:04:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jgarzik@pobox.com>
cc: Tejun Heo <htejun@gmail.com>, Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
In-Reply-To: <46604E62.1000105@pobox.com>
Message-ID: <alpine.LFD.0.98.0706010955390.3957@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
  <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com> 
 <46599E6B.1000209@pobox.com>  <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com>
  <alpine.LFD.0.98.0705270922030.26602@woody.linux-foundation.org> 
 <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com> 
 <465AA536.6080608@gmail.com> <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com>
 <465BF244.5080200@gmail.com> <alpine.LFD.0.98.0705290924350.26602@woody.linux-foundation.org>
 <465F6F48.8080804@gmail.com> <alpine.LFD.0.98.0705311830360.26602@woody.linux-foundation.org>
 <465F8230.2040105@gmail.com> <46604E62.1000105@pobox.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Jeff Garzik wrote:
> 
> I'm about to dive into some heads-down RHEL backporting (whee), so I cannot
> look at the code in depth this weekend, but here are my basic thoughts:
> 
> * We knew there would be fallout from the new reset-sequence code, and this is
> clearly in that category.
> 
> * It worked before #reset-seq merge AFAICT, which implies the old method of
> probing -- which included SRST -- worked.

Well, I don't think it really "worked" before. It apparently always had a 
bad 30-second timeout (probably because the reset just didn't work at 
all). It's just that the old code didn't care, and since the identify then 
worked, it was all good.

		Linus
