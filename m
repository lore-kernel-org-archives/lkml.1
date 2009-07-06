Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZGFUbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZGFUbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZGFUbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:31:13 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1058 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbZGFUbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:31:13 -0400
Subject: Re: [PATCH] Remove multiple KERN_ prefixes from printk formats
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <8bd0f97a0907061323j3480fa61sa7f44d71819a076d@mail.gmail.com>
References: <4A4C3410.8080704@kernel.org>
	 <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
	 <1246513356.28915.62.camel@Joe-Laptop.home>
	 <alpine.LFD.2.01.0907021020200.4830@localhost.localdomain>
	 <1246556320.28915.92.camel@Joe-Laptop.home>
	 <alpine.LFD.2.01.0907021043160.4830@localhost.localdomain>
	 <1246910740.4643.10.camel@Joe-Laptop.home>
	 <8bd0f97a0907061323j3480fa61sa7f44d71819a076d@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 13:29:54 -0700
Message-Id: <1246912194.4643.13.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 16:23 -0400, Mike Frysinger wrote:
> thanks, i had started this in the Blackfin code a little, but your
> patch includes what i did and more, so the Blackfin stuff should be
> mostly fine (pending comments below).
[]
> > -       printk(KERN_EMERG "\n" KERN_EMERG "Double Fault\n");
> > +       printk(KERN_EMERG "Double Fault\n");
> 
> dropped a newline.  we've largely made sure the newlines and such were
> as we want in the output ... in this case, it is not a matter of
> adding a newline where one did not exist before

Hi Mike.

I'm of the opinion that blank lines in the log file
aren't very useful, but as you like, it's your code.

