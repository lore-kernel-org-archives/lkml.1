Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbZACAED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbZACAED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 19:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZACADx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 19:03:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:38586 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbZACADw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 19:03:52 -0500
Date: Fri, 2 Jan 2009 16:05:25 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headers_check.pl: disallow extern's
Message-ID: <20090102160525.430c59f9@infradead.org>
In-Reply-To: <200901030059.18438.arnd@arndb.de>
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org>
	<200812311758.04516.arnd@arndb.de>
	<200812311732.40076.vapier@gentoo.org>
	<200901030059.18438.arnd@arndb.de>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Jan 2009 00:59:18 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 31 December 2008, Mike Frysinger wrote:
> > On Wednesday 31 December 2008 11:58:03 Arnd Bergmann wrote:
> >
> > > Not sure if we can detect the other form reliably from perl.
> > 
> > yes, i already mentioned both of these issues.  that's why i
> > suggested we start adding "extern" to all the headers (or at least
> > the userspace ones).
> 
> The general trend seems to be to remove the "extern" keyword from
> kernel headers, because it is not interpreted, just like the 'auto'
> keyword. In fact, only few of them currently carry the extern keyword:
> 
> $ ctags -f- -R --c-kinds=p obj/usr/include/  | grep extern | wc -l
> 33
> 
> $ ctags -f- -R --c-kinds=p obj/usr/include/  | grep -v extern | wc -l
> 191
> 
> Note that this is a completely separate issue from extern variable
> declarations, which should to be disallowed in any case, and are easy
> to detect as they always require the extern keyword.

in addition... what business does the kernel have to provide function
prototypes to userspace, other than the system call prototypes?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
