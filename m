Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbXFIMJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbXFIMJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 08:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbXFIMJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 08:09:37 -0400
Received: from panic.printk.net ([217.147.83.20]:57077 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbXFIMJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 08:09:37 -0400
Subject: Re: Size of kernel modules
From: Jon Masters <jonathan@jonmasters.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Kyle McMartin <kyle@canonical.com>,
       Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706090954310.4353@fbirervta.pbzchgretzou.qr>
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
	 <20070608034421.GM26717@fattire.cabal.ca>
	 <Pine.LNX.4.64.0706080838210.17480@localhost.localdomain>
	 <Pine.LNX.4.64.0706090954310.4353@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 09 Jun 2007 08:08:31 -0400
Message-Id: <1181390911.3306.22.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-09 at 09:55 +0200, Jan Engelhardt wrote:
> On Jun 8 2007 08:40, Robert P. J. Day wrote:
> >>
> >> If you disable CONFIG_DEBUG_KERNEL, things should go back to normal
> >> sizes for you.
> >
> >grow so much compared to *which other modules*?  the ones that came
> >with your distro?  if that's the case, try installing your new modules
> >with
> >
> >  # make INSTALL_MOD_STRIP=1 modules_install
> >
> >that makes a *huge* difference in the size of the installed modules,
> >as i learned when i first ran across this on my fedora core system.
> 
> Definitely. Running depmod on debug-enabled .ko files explodes in a segfault
> after depmod allocates more and more and more memory (exhausting both 
> my ram and swap).

So I missed half of this conversation - you're saying that on a
CONFIG_DEBUG_KERNEL, you have such large .ko module files that depmod
segfaults? Can I get a core dump or any further information? :-)

Jon.


