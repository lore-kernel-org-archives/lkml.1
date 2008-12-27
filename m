Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYL0S4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYL0S4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 13:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYL0Sz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 13:55:56 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:59100 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbYL0Szz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 13:55:55 -0500
Date: Sat, 27 Dec 2008 19:57:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Frysinger <vapier@gentoo.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
Message-ID: <20081227185727.GB10442@uranus.ravnborg.org>
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <20081227071208.GB27736@uranus.ravnborg.org> <20081227084708.GA16077@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227084708.GA16077@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 09:47:08AM +0100, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Sat, Dec 27, 2008 at 01:50:04AM -0500, Mike Frysinger wrote:
> > > Use __asm__/__inline__ rather than asm/inline for all the functions
> > > exported to userspace.
> > 
> > I will imagine that we will see cleanup patches converting
> > these back to inline/asm.
> > How about doing this conversion as part of the headers_install.pl
> > script so we know it is always correct?
> > 
> > Then we can keep the familiar inline/asm in the kernel headers
> > and always use the correct __asm__, __inline__ version for our
> > exported headers.
> 
> or name it __asm__exported__ to make sure it isnt cleaned up away.

I wnet with the scripted conversion for now.
If that does not fly we can come back to this proposal.

What I like most with the auto conversion is that we avoid
adding yet another special rule about how to do stuff in exported headers.

	Sam
