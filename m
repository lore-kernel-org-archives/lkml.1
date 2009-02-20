Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbZBTI2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbZBTI2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZBTI2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:28:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:54600 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbZBTI2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:28:14 -0500
Subject: Re: [PATCH] x86: remove unneeded endless loop in BUG()
From: Petr Tesarik <ptesarik@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <499DC5A6.1080305@zytor.com>
References: <1235068713.15053.99.camel@nathan.suse.cz>
	 <20090219185935.GA21820@elte.hu> <499DB8BA.3050708@zytor.com>
	 <499DC545.2030402@goop.org>  <499DC5A6.1080305@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Fri, 20 Feb 2009 09:28:08 +0100
Message-Id: <1235118488.15053.102.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin píše v Čt 19. 02. 2009 v 12:48 -0800:
> Jeremy Fitzhardinge wrote:
> > 
> > There's no reason to expect an "asm volatile" to stay put; the 
> > "volatile" has nothing to do with preventing code motion.  The only way 
> > to make an asm stick in one place is with data dependencies, and I'm not 
> > sure what the dependency for __builtin_trap might be.  I'm guessing its 
> > a "memory" clobber, but that's pure guesswork.
> > 
> 
> I looked through this with HJL; the bottom line is that although it 
> probably would work, it's not worth it.
> 
> I submitted GCC bug 39252 to get __builtin_not_reached(); instead.

Thank you! I like it this way, too.

Petr Tesarik


