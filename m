Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbZGFUkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbZGFUkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZGFUj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:39:58 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1076 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbZGFUj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:39:57 -0400
Subject: Re: [PATCH] Remove multiple KERN_ prefixes from printk formats
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0907061332040.3210@localhost.localdomain>
References: <4A4C3410.8080704@kernel.org>
	 <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
	 <1246513356.28915.62.camel@Joe-Laptop.home>
	 <alpine.LFD.2.01.0907021020200.4830@localhost.localdomain>
	 <1246556320.28915.92.camel@Joe-Laptop.home>
	 <alpine.LFD.2.01.0907021043160.4830@localhost.localdomain>
	 <1246910740.4643.10.camel@Joe-Laptop.home>
	 <8bd0f97a0907061323j3480fa61sa7f44d71819a076d@mail.gmail.com>
	 <alpine.LFD.2.01.0907061332040.3210@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 13:38:13 -0700
Message-Id: <1246912693.4643.17.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 13:33 -0700, Linus Torvalds wrote:
> 
> On Mon, 6 Jul 2009, Mike Frysinger wrote:
> > >  #ifdef CONFIG_DEBUG_VERBOSE
> > > -       printk(KERN_EMERG "\n" KERN_EMERG "Double Fault\n");
> > > +       printk(KERN_EMERG "Double Fault\n");
> > 
> > dropped a newline.  we've largely made sure the newlines and such were
> > as we want in the output ... in this case, it is not a matter of
> > adding a newline where one did not exist before
> 
> Note that the 'printk' itself will add a required newline these days.
> 
> So unless you want an _empty_ line due to an earlier '\n', the change is 
> correct.

Note the prefix before and after the "\n"
I believe he _wants_ an empty line.


