Return-Path: <linux-kernel-owner+w=401wt.eu-S965741AbXCPUIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965741AbXCPUIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965735AbXCPUIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:08:55 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:38484 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965719AbXCPUIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:08:54 -0400
Date: Fri, 16 Mar 2007 21:09:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Kconfig style question
Message-ID: <20070316200927.GB22200@uranus.ravnborg.org>
References: <7Z7fc-4ZL-21@gated-at.bofh.it> <E1HS7G6-0001Cr-19@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HS7G6-0001Cr-19@be1.lrz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 08:53:53AM +0100, Bodo Eggert wrote:
> Kumar Gala <galak@kernel.crashing.org> wrote:
> 
> > For source lines I've seen both:
> > 
> > source "arch/powerpc/platforms/52xx/Kconfig"
> > 
> > and
> > 
> > source arch/powerpc/platforms/85xx/Kconfig
> > 
> > Is there a preferred style?  Quotes or not?
> 
> $ find . -name Kconfig -exec grep ^source '{}' \;|grep \"|wc -l
>     732
> $ find . -name Kconfig -exec grep ^source '{}' \;|grep -v \"|wc -l
>      44

Which is somewaht funny.
source is defined like this:
"source" <prompt>

Where <prompt> may be a single string without spaces or
a quoted string with spaces.
So kconfig allow you to use spaces in the path/filename. But
then most users uses "" despite it is not needed since we obviously
do not use spaces in path/filename in the kernel due to
make limitations (and good taste).

	Sam
