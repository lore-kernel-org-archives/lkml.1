Return-Path: <linux-kernel-owner+w=401wt.eu-S1764080AbYCEHkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764080AbYCEHkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbYCEHjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:39:51 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:38252 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbYCEHju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:39:50 -0500
Date: Wed, 5 Mar 2008 08:40:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.25-rc3-mm1 (wakeup)
Message-ID: <20080305074004.GA15400@uranus.ravnborg.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <20080304122414.f4b7e7f7.randy.dunlap@oracle.com> <200803042333.13300.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803042333.13300.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 11:33:12PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, 4 of March 2008, Randy Dunlap wrote:
> > On Tue, 4 Mar 2008 01:19:28 -0800 Andrew Morton wrote:
> > 
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/
> > 
> > Both x86_64 and i386 builds throw these messages at me:
> > 
> >   LD      arch/x86/kernel/acpi/realmode/wakeup.elf
> > ld: warning: dot moved backwards before `.text'
> > ld: warning: dot moved backwards before `.text'
> > ld: warning: dot moved backwards before `.text'
> >   OBJCOPY arch/x86/kernel/acpi/realmode/wakeup.bin
> 
> I think I saw something like this on a system with an "older" toolchain.
> I'm not seeing it on openSUSE 10.3, though (using gcc 4.2.1).
> 
> Added CCs to the experts. 
Google turned up this post:
http://sourceware.org/ml/binutils/2006-08/msg00235.html

I have no time to dig more into it the next days.

	Sam
