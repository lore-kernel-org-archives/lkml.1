Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbXHVGGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbXHVGGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 02:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbXHVGGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 02:06:11 -0400
Received: from mx12.go2.pl ([193.17.41.142]:53073 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817AbXHVGGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 02:06:10 -0400
Date: Wed, 22 Aug 2007 08:07:13 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-arch@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Wedgwood <cw@f00f.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       linux-mips@linux-mips.org, Oliver Pinter <oliver.pntr@gmail.com>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       len.brown@intel.com
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070822060713.GA1684@ff.dom.local>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <20070821191959.GC2642@bingen.suse.de> <20070821195433.GE30705@stusta.de> <alpine.LFD.0.999.0708211306560.30176@woody.linux-foundation.org> <20070821202113.GF30705@stusta.de> <27c412eea99f1f80a3002e9668bd31f8@kernel.crashing.org> <20070821212129.GG30705@stusta.de> <17c0b56b663fce6f28b46e3c42dfbaf9@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17c0b56b663fce6f28b46e3c42dfbaf9@kernel.crashing.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:08:33AM +0200, Segher Boessenkool wrote:
> >>>How many people e.g. test -rc kernels compiled with gcc 3.2?

I confirm gcc version:

~/src/linux-2.6.23-rc3$ gcc -v
Reading specs from /usr/lib/gcc-lib/i486-slackware-linux/3.2.3/specs
Configured with: ../gcc-3.2.3/configure --prefix=/usr --enable-shared
 --enable-threads=posix --enable-__cxa_atexit --disable-checkingi
 --with-gnu-ld --verbose --target=i486-slackware-linux
 --host=i486-slackware-linux
Thread model: posix
gcc version 3.2.3

glibc-2.3.2

Sorry, you have to guess this, but, after reporting long time ago some
acpi make warnings, I didn't even suspect anybody would be interested
more this time...

It's an old box with Slackware 9.1, and this make is the last stage
of testing such a hot kernel version... But, according to README gcc
3.2 seems to be legal. (I hope there would be some warning about gcc
too old, anyway.)

Cheers,
Jarek P.
