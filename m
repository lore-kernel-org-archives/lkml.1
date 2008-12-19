Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYLSIJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYLSIJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 03:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYLSII7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 03:08:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:49429 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYLSII6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 03:08:58 -0500
Date: Fri, 19 Dec 2008 09:08:56 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, bluebird@gentoo.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH-2.6.28 final] byteorder: fix new headers for userspace
Message-ID: <20081219090856.48666b14@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0812181246420.14014@localhost.localdomain>
References: <4943DAD6.7070402@gentoo.org>
	<20081216.011334.124918024.davem@davemloft.net>
	<1229564779.6481.26.camel@brick>
	<alpine.LFD.2.00.0812181208070.14014@localhost.localdomain>
	<alpine.LFD.2.00.0812181246420.14014@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 12:47:28 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 18 Dec 2008, Linus Torvalds wrote:
> > 
> > I think it would be better to just make it a config option, call it 
> > CONFIG_[LITTLE|BIG]_ENDIAN and set it up in the architecture
> > Kconfig file. I think some of the people who can set it dynamically
> > (or where it depends on the target machine) already effectively do
> > that.
> 
> Never mind, since we end up having to export it to user space (do
> we?) we can't depend on the config.h file, nor can we pollute the
> name space.
> 

why are we exposing byte order functions to userspace in the first
place ????


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
