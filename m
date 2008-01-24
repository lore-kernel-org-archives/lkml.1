Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbYAXV1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbYAXV1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbYAXV1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:27:34 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:44880 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbYAXV1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:27:33 -0500
Date: Thu, 24 Jan 2008 22:27:43 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Jones <davej@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Recursive variable `KBUILD_CFLAGS' references itself (eventually).
Message-ID: <20080124212743.GB3944@uranus.ravnborg.org>
References: <20071120001445.GA9243@redhat.com> <20071231131619.GE21871@uranus.ravnborg.org> <20071231161021.GC27655@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231161021.GC27655@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 11:10:21AM -0500, Dave Jones wrote:
> On Mon, Dec 31, 2007 at 02:16:19PM +0100, Sam Ravnborg wrote:
> 
>  > > Trying to do a 32bit build on a 64bit machine.
>  > > I did..
>  > >   make ARCH=i386 oldconfig
>  > >   make ARCH=i386 arch/x86/
>  > 
>  > Walking through my mailbox I found this one.
>  > I did not get similar reports and I cannot reproduce it.
>  > Do you continue to see this or had it been fixed somehow?
> 
> Still happens for me with the latest tree from git.
> 
> $ make ARCH=i386 arch/x86/

There is no easy fx for this one.
You try to build one of the non-standard directories and it just
fails because arch/x86/Makefile is not a regular Kbuild file.

Try with any other directory (almost any other) and it works.
Considered unfortunate but not a bug - so I will not try to fix it.

	Sam
