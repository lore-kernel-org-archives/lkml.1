Return-Path: <linux-kernel-owner+w=401wt.eu-S1759681AbXFMSnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681AbXFMSnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbXFMSnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:43:10 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:36906 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbXFMSnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:43:09 -0400
X-Greylist: delayed 1991 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 14:43:08 EDT
Date: Wed, 13 Jun 2007 14:09:53 -0400
To: Bernd Paysan <bernd.paysan@gmx.de>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070613180953.GA18512@delft.aura.cs.cmu.edu>
Mail-Followup-To: Bernd Paysan <bernd.paysan@gmx.de>,
	Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <200706131402.11396.bernd.paysan@gmx.de> <m33b0w80dg.fsf@maximus.localdomain> <200706131624.37211.bernd.paysan@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706131624.37211.bernd.paysan@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 04:24:36PM +0200, Bernd Paysan wrote:
> There's no point of discussing that the Linux kernel *as a whole* (as 
> compilation) currently is under GPLv2 only, since it sais so, and a few 
> files also explicitely say so. The whole combination is GPLv2 only, but 
> most parts aren't.

You claim that any source files without a notices are 'any version of
the GPL'. But I read the license and you are totally wrong about that.

The GPL applies to "the Program" which in this case is the Linux kernel
as a whole and it in fact does indicate a specific version. All code
submitted and included in this program has has been submitted with the
understanding that the work as a whole is specifically licensed as
GPLv2. Some authors have granted additional rights, such as dual BSD/GPL
or GPLv2 and later and explicitly added such a notice.

All other code is simply copyrighted, and the only available license is
the GPLv2. Take for example fs/inode.c. Notice how it doesn't have GPL
boilerplate, but it is clearly indicating that it is copyrighted. So
taking that file by itself out of the context of the kernel and then
distributing it would clearly be a copyright violation. The only one
reason you can distribute that code is because of the GPLv2 that covers
the Linux kernel (i.e. "the Program").

> > > So my conclusion is: If you, as contributor to the Linux kernel, want
> > > to make clear that your work really is GPLv2 only, you have to do that
> > > yourself, you have to add a notice like above to files where you
> > > exclusively own copyright.

The kernel is explicitly licensed as GPLv2, any contributions (source
files/parts of the work) that wish to grant additional rights have to
specify so explicitly, and not the other way around however much you'd
like that.

> patches as the mainline kernel), I'm free to choose under which conditions 
> I redistribute it, given that it's compatible with the conditions the 
> original authors have chosen. Most of them have said nothing (other than 
> implicitely that it's ok for them to put it under GPL, as they haven't 
> opposed to inclusion into the Linux kernel), some have said GPLv2 or later, 

Reread section 9 and consider that "the Program" is the Linux kernel,
which does explicitly state a version and does not include the "and any
later" option. Any source that does not explicitly specify additional
rights is GPLv2.

Jan

