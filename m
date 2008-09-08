Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbYIHQ0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbYIHQ0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYIHQ0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:26:44 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:47458 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYIHQ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:26:43 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Date: Mon, 8 Sep 2008 12:26:35 -0400
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <48C54F1B.8040604@zytor.com> <48C54FA0.10302@kernel.org>
In-Reply-To: <48C54FA0.10302@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081226.37283.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008 12:15, H. Peter Anvin wrote:
> H. Peter Anvin wrote:
> > The issue at hand is that at least with the current toolchain, we need
> > to pass -march=generic in order for these instructions to be generated.
> >  We have an option for this, CONFIG_X86_GENERIC, which distributions
> > really *should* be using anyway.
>
> That should have been "-mtune=generic".  Sorry.
>
> > And yes, it should be the default.  The patch I have makes it
> > "default y" as well as change the help text.
> >
> > Would it make you happier if this option was forced enabled unless
> > CONFIG_EMBEDDED was on?
>
> I guess the other option is to create a new option for selecting the
> dangerous -mtune= variants, and possibly lock *that* option to
> CONFIG_EMBEDDED.
>
> 	-hpa

The option that works best for users is for the kernel to not use NOPLs on 
32-bit cpu's.  That is what Linus's patch accomplishes.  I am not having any 
issues with gcc or gas generating NOPLs.  The kernel should work out of the 
box for PentiumPro or later cpu's running in 32-bit mode.  I think you are 
trying to over-engineer the issue.  Just apply the patch and move on.
David
