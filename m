Return-Path: <linux-kernel-owner+w=401wt.eu-S932355AbZDIVwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbZDIVwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbZDIVwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:52:10 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:51352 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757026AbZDIVwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:52:09 -0400
Date: Fri, 10 Apr 2009 07:52:07 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-ID: <20090409215207.GN16602@bilbo.ozlabs.org>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ia64@vger.kernel.org
References: <20090408003921.GA5054@ldl.fc.hp.com> <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com> <20090407225457.86f8a458.akpm@linux-foundation.org> <20090409003308.GK16602@bilbo.ozlabs.org> <20090408174443.79e71503.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090408174443.79e71503.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 05:44:43PM -0700, Andrew Morton wrote:

> Please do.

linux-next is built on powerpc so I needed to rebuild many of the compilers for
intel.

While I was there I "updated to 4.3.3 and a 4.4.0 snapshot (20090216).

I've placed (well am placing):

x86_64 host, gcc 4.3.3, binutils 2.19.1:
alpha-linux
arm-linux
avr-linux
cris-linux
hppa64-linux
hppa-linux
i386-linux
m68k-linux
mipsel-linux
mips-linux
powerpc-linux
s390x-linux
sparc-linux
xtensa-linux

x86_64 host, gcc 4.4.0-20090216, binutils 2.19.1:
alpha-linux
arm-linux
avr-linux
cris-linux
hppa64-linux
i386-linux
m68k-linux
powerpc-linux
s390x-linux
sparc-linux

I haven't succeeded in builting a ia64 compiler, but I'll keep trying.

The i386,powerpc and sparc compilers are biarch and seem to build the 32/64
kernels appropriately.

I'm building i386 hosted compiiler ATM and I'll uplaod them when done.

Looking at the 4.3.3 compilers, asside from ia64 what arches are missing?

> Several people have made suggestions but I don't think I've yet seen
> anything which is download-and-go.  Many of them appear to be ways of
> tricking people into installing distributions which include dselect,
> but I'm awake to their little games.

These should all be relocatable, in that you can wack them anywhere (/opt/cross
for me) and set your CROSS_COMPILE var and go.

For what it's worth these compilers were built with something derrived from
the buildall scripts by Segher (http://git.infradead.org/users/segher/buildall.git)

Thanks Segher!

Yours Tony
