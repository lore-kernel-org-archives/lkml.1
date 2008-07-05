Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYGEPyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYGEPyo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 11:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYGEPyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 11:54:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:36987 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbYGEPyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 11:54:32 -0400
Date: Sat, 5 Jul 2008 08:54:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Battery life difference
Message-ID: <20080705085432.2f9b2964@infradead.org>
In-Reply-To: <31e679430807050844r30ff74fby7e15641573b42d82@mail.gmail.com>
References: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com>
	<20080705082352.4b6be669@infradead.org>
	<31e679430807050844r30ff74fby7e15641573b42d82@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008 18:44:21 +0300
"Felipe Balbi" <felipebalbi@users.sourceforge.net> wrote:
> hmm... interesting :-)
> where should i look for more info ? Any pointers would be nice
> 
> > There's a few things you can do to help stuff along; make sure
> > you're using AHCI.
> 
> not loaded. Thanks

you may also need to toggle your bios to enable AHCI btw

> 
> > Also take a look at
> > http://kerneltrap.org/mailarchive/linux-kernel/2008/5/8/1771024
> > because these patches save like 0.75W in our lab.
> 
> cool, is it merged upstream ?
> I'll build current git kernel and reply again with new linux results.
> It could be that ubuntu 2.6.24 is broken somehow...
> 
> > To be honest, I'm surprised at your results; in our testing (with a
> > different distro though) we don't see such a difference and Linux is
> > doing rather well.
> 
> can you get powertop results in a 2.6.24 distro kernel and current git
> kernel ?

most of my measurement machines are in the office ;(

Anyway, also make sure you use the 0.11 version of powertop; we added
some newer stuff into that version...

> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
