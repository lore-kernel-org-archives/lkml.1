Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbXLNSkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbXLNSkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXLNSkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:40:25 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:37135 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbXLNSkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:40:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 19:38:09 +0100
User-Agent: KMail/1.9.6
Cc: Ray Lee <ray-lk@madrabbit.org>, stefano.brivio@polimi.it,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Daniel Walker <dwalker@mvista.com>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, mbuesch@freenet.de, linux@bohmer.net,
       kjwinchester@gmail.com, jonathan@jonmasters.org,
       akpm@linux-foundation.org, bcm43xx-dev@lists.berlios.de
References: <20071213003028.676998182@mvista.com> <200712141759.59273.mb@bu3sch.de> <20071214175910.GA27078@elte.hu>
In-Reply-To: <20071214175910.GA27078@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712141938.10733.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 18:59:10 Ingo Molnar wrote:
> 
> * Michael Buesch <mb@bu3sch.de> wrote:
> 
> > In my opinion this all is the work of the distributions and not the 
> > work of the kernel developers. Distributions have to make sure that 
> > everything works after a kernel update. [...]
> 
> actually, not. The the task of kernel developers is to KEEP OLD 
> DISTRIBUTIONS WORKING WITH NEW DRIVERS. Or the "old" driver stays around 
> until eternity, because the new one is just BROKEN.

What exactly prevents an old distribution from using new b43
given that they fix their broken udev scripts first?

(I cannot fix their broken scripts from within the kernel.)

> Take a look at CONFIG_COMPAT_VDSO for example - one single version of 
> glibc was released in a distro that depended on a kernel vDSO bug. So 
> we'll keep that aspect of the vDSO perhaps forever. Simple as that. 
> Stuff must just work. Whatever it takes. Best is if you add in new stuff 
> without the user noticing _ANYTHING_ but that the kernel version bumped. 
> If the maintainers of the other 7 million lines of kernel code can get 
> this right then the wireless code should be able to do it too. Ok?
> 
> all this "distributors will have to sort out the mess" talk is nonsense, 
> and i really hope you do not truly believe in that crap. If your 
> attitude is prevalent in the wireless development community then it's in 
> worse shape than i thought :-(

Sorry if I didn't chose my wording correctly. But I was only talking
about the development of drivers. It is correct that userspace ABI has
to be preserved, but that is not an issue at all to drivers.
I was talking about things like installing the right firmware for
the new driver. It is the job of the distributors to install the new
firmware when they introduce a new driver. It is the job of the distributors
to test their userland scripts and configuration stuff with that driver
and fix their stuff. It is _not_ my job to fix random distribution
udev scripts or explaining over and over again to people how the firmware
is installed. Either distributions have to install it automatically
or people simply have to read one or two lines of documentation.
That's just what I wanted to say.

Of course it is _my_ job to preserve ABI. I did never want to question that.

-- 
Greetings Michael.
