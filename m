Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYDJBl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYDJBl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 21:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYDJBlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 21:41:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbYDJBlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 21:41:46 -0400
Date: Wed, 9 Apr 2008 18:40:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Frans Pop <elendil@planet.nl>, Ingo Molnar <mingo@elte.hu>,
       jeff@garzik.org, matthew@wil.cx, auke-jan.h.kok@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, linux-pci@atrey.karlin.mff.cuni.cz,
       akpm@linux-foundation.org, davem@davemloft.net,
       jesse.brandeburg@intel.com, john.ronciak@intel.com,
       bruce.w.allan@intel.com, greg@kroah.com, arjan@linux.intel.com,
       rjw@sisk.pl
Subject: Re: [patch] e1000=y && e1000e=m regression fix (was: Re: [regression]
 e1000e broke e1000)
In-Reply-To: <m363uqwpds.fsf@maximus.localdomain>
Message-ID: <alpine.LFD.1.00.0804091838330.3143@woody.linux-foundation.org>
References: <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <20080408193245.GG11962@parisc-linux.org> <20080408195123.GA28148@elte.hu> <47FBCE00.2020309@garzik.org> <20080408200652.GC28148@elte.hu>
 <47FBD34A.6080508@garzik.org> <20080408203314.GA28952@elte.hu> <47FBDBE9.9040700@garzik.org> <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <200804092249.23111.elendil@planet.nl> <m363uqwpds.fsf@maximus.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Apr 2008, Krzysztof Halasa wrote:
> 
> Nope, udev with normal distro config will load e1000e just fine.

Not for us that don't compile modules at all, or only modules for the 
devices we actually have.

Which should be about 99% of all kernel developers, because otherwise 
you're just wasting your time.

I certainly want the configurations to be sane by default, because I'm not 
in the insane camp that has every single module and depend on udev picking 
the right one out.

			Linus
