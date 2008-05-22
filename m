Return-Path: <linux-kernel-owner+w=401wt.eu-S935097AbYEVBUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935097AbYEVBUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762362AbYEVBUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 21:20:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760000AbYEVBUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 21:20:35 -0400
Date: Wed, 21 May 2008 18:20:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Paul Mackerras <paulus@samba.org>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
In-Reply-To: <20080522005657.GU28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org> <18484.44691.477859.334222@cargo.ozlabs.ibm.com> <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org>
 <20080522005657.GU28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 May 2008, Al Viro wrote:
> 
> Eh?  git mv include/asm-$i arch/$i/include/asm, then?

Yeah, sorry, I dropped an "include/" there. 

> Nice, but... how do you pull what's currently asm-generic/foo.h from what's
> currently asm-bar/foo.h?  #include_next is _ugly_...

I was actually going to suggest #include_next, yes. But if people hate it, 
we can certainly just keep the current <asm-generic/xyz.h> approach.

		Linus
