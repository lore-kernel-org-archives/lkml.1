Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbZGLV4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbZGLV4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 17:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZGLV4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 17:56:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:38787 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZGLV4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 17:56:45 -0400
Date: Sun, 12 Jul 2009 14:58:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Message-ID: <20090712145804.2f1fce98@infradead.org>
In-Reply-To: <20090712173329.GB12054@kroah.com>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com>
	<200907121410.39874.rusty@rustcorp.com.au>
	<20090712004524.2f0c4e57@infradead.org>
	<200907121928.28887.rusty@rustcorp.com.au>
	<20090712083227.39939849@infradead.org>
	<20090712173329.GB12054@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009 10:33:29 -0700
Greg KH <greg@kroah.com> wrote:

> > 
> > 105 is also a sign that you picked a somewhat suboptimal config...
> > that's of course your choice but it's a choice that has a small
> > price, if you don't want to pay that price, changing the config to
> > not be entirely insane is a good answer as well ;-)
> 
> But this is the "common" case in the world of Linux where the distros
> are forced to build everything as modules. 

who's holding the stick?
Really.

I've seen some of these case, where the distro kernel has something as
a module, but the other parts of the distro the unconditionally load
that module always. That makes no sense.
If you have 105 different real devices in your system, that have
different drivers, sure, I'll buy 105. Somehow I doubt Rusty's box has
105 ;)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
