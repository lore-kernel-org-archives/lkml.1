Return-Path: <linux-kernel-owner+w=401wt.eu-S1765639AbYEESty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765639AbYEESty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761509AbYEESoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:44:03 -0400
Received: from ozlabs.org ([203.10.76.45]:59386 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761763AbYEESn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:43:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: changeset: Make forced module loading optional
Date: Tue, 6 May 2008 04:42:12 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <200805051455.02723.rusty@rustcorp.com.au> <200805051535.05370.rusty@rustcorp.com.au> <alpine.LFD.1.10.0805050957590.32269@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805050957590.32269@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805060442.12440.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2008 03:07:03 Linus Torvalds wrote:
> On Mon, 5 May 2008, Rusty Russell wrote:
> > BTW, for the peanut gallery: I don't recommend modversions: it's not
> > reliable in detecting all differences, nor being stable when there are no
> > real differences.
...
> So I agree that modversions is not "reliable", but I think that the
> alternative is often even *less* reliable, so I find the "don't recommend
> modversions" comment to be pretty debatable.

Kids: do not shove random modules into your kernel.  Just because Linus does 
something doesn't make it a good idea.  modversions tries to be clever, but 
don't count on it; you want module signing for this (where did those patches 
go?)

BTW, I'm fascinated and a little nausiated that you ignore initrds.  We've 
moved half the kernel brains to userspace with udev, initrd and modules; it's 
really unfair that you're not sharing all that why-won't-my-machine-boot 
love.

Cheers,
Rusty.
