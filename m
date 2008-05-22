Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbYEVBa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbYEVBa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbYEVBaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 21:30:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755483AbYEVBaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 21:30:19 -0400
Date: Wed, 21 May 2008 18:29:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Paul Mackerras <paulus@samba.org>,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
In-Reply-To: <1211419419.6908.12.camel@brick>
Message-ID: <alpine.LFD.1.10.0805211827010.3081@woody.linux-foundation.org>
References: <s5hzlqjz74d.wl%tiwai@suse.de>  <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org>  <18484.44691.477859.334222@cargo.ozlabs.ibm.com>  <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org>  <20080522005657.GU28946@ZenIV.linux.org.uk>
  <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org> <1211419419.6908.12.camel@brick>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 May 2008, Harvey Harrison wrote:
> 
> What about say, sparc64 that has a lot of #include <asm-sparc/foo.h>

Ahh, I didn't realize people did that.

I assume (but am too lazy to check) that UML probably does something 
similar for its arch-specific stuff.

So yeah, it's probably more pain than it _should_ be, for reasons like 
that.

But I suspect that things like <asm-sparc/foo.h> may be because sparc64 
would actually like to add another -Iarch/sparc/include (until it 
eventually can get rid of the thing _entirely_, of course, as it gets 
unified under one architecture)

		Linus
