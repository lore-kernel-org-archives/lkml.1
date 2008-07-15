Return-Path: <linux-kernel-owner+w=401wt.eu-S1760980AbYGOWVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbYGOWVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYGOWUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:20:53 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:37099 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbYGOWUw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:20:52 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Wed, 16 Jul 2008 00:20:48 +0200
User-Agent: KMail/1.9.9
Cc: david@lang.hm, Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, jeff@garzik.org,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <alpine.DEB.1.10.0807151426021.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151436400.2867@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151436400.2867@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200807160020.49496.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jul 2008 22:20:49.0970 (UTC) FILETIME=[0958F920:01C8E6C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008, you wrote:
> Why is it suddenly so important that a kernel be 'zero impact' for that
> module case, when it's never been zero impact for that case before? You
> had to rewrite the initrd to begin with, but now you're not willing to
> do it again, just because you have to rewrite it slightly
> _differently_?

Because in most cases users do not write and maintain the scripts used to 
build custom kernels themselves. They use (huge and way too) tools like 
Debian's 'make-kpkg' for that.

Because users may want to build a custom 2.6.27 in for example a Debian 
Etch environment using the make-kpkg package that is available in that 
release of Debian. Or even a Debian Lenny environment (Lenny is about to 
be frozen so is very unlikely to include whatever may be needed for 
this).

Why is it good to extend the lifetime of the i386 and amd64 symlinks for 
x86 images by an extra few years so that older versions of kernel 
packaging tools - like make-kpkg - don't break, but is breaking the exact 
same tools with this firmware change suddenly OK?

Users _want_ to be able to build new kernels in older environments. Why 
take that option away from them? Why force them through the pain of 
partial upgrades of their userspace if it can so easily be avoided?

>From my PoV adding this option is a no-brainer: if Jeff is willing to do 
the work, then what harm can it do? The benefits to me are obvious.
I really don't get what you have against it.

Cheers,
FJP

P.S. Sorry to keep coming up with Debian examples, but that's the 
environment I know.
