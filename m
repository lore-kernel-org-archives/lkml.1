Return-Path: <linux-kernel-owner+w=401wt.eu-S1765549AbYDYTt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765549AbYDYTt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbYDYTtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:49:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:35144 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbYDYTtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:49:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EN9xhUJHucNzIA1OaEryIpyFOyKwVqsm1H+zFQNlHDVP5F6qdeOYWYe8mHlEq2fTq5JiMV80wpX87pUwxeHdvhobLTHfM2mvGyTGThtTNXuk0USKFVylA1gaqeAyRfelI9OmSKH04ZRrwWP35TVHQOT4KeBuYeLnGWh8Eb9rX+0=
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804251243590.2779@woody.linux-foundation.org>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com>
	 <1209078352-7593-2-git-send-email-hpa@zytor.com>
	 <1209078352-7593-3-git-send-email-hpa@zytor.com>
	 <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr>
	 <alpine.LFD.1.10.0804251133100.2779@woody.linux-foundation.org>
	 <20080425185251.GL14990@parisc-linux.org> <48122CB0.7020003@zytor.com>
	 <20080425192858.GM14990@parisc-linux.org> <48123325.30003@zytor.com>
	 <alpine.LFD.1.10.0804251243590.2779@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 12:49:16 -0700
Message-Id: <1209152956.14173.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 12:45 -0700, Linus Torvalds wrote:
> 
> On Fri, 25 Apr 2008, H. Peter Anvin wrote:
> > 
> > I have to admit to liking the Windows extension %I64u for this kind of stuff.
> > Unfortunately gcc/glibc decided to use I for internationalized digits instead
> > :(
> 
> The sad part is that this is purely a gcc thing. We could easily do the 
> right thing in the kernel vsnprintf stuff, but then we'd have to drop the 
> nice format warnings from gcc ;(

This looks like something sparse could be made to check though, should
we lose the gcc checking.

In fact, didn't Al Viro mention adding just this kind of checking to
sparse recently?

Harvey

