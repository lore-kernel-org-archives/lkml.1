Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYL0TZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYL0TZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 14:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYL0TZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 14:25:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59370 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbYL0TZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 14:25:00 -0500
Message-ID: <495680F3.1040707@zytor.com>
Date: Sat, 27 Dec 2008 11:24:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, Mike Frysinger <vapier@gentoo.org>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <20081227071208.GB27736@uranus.ravnborg.org> <20081227084708.GA16077@elte.hu> <20081227185727.GB10442@uranus.ravnborg.org> <49567AC3.4030507@zytor.com> <20081227191223.GA10592@uranus.ravnborg.org> <49567EB5.5030409@zytor.com> <20081227192430.GC10592@uranus.ravnborg.org>
In-Reply-To: <20081227192430.GC10592@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> I was only thinking of a warning so we could have this part cleaned up.
> It is for the most part a trivial task to do for a volunteer.
> 

Why do a warning and then have people hack it manually?  If we do it
automatically, we should be able to get rid of *another* special rule
for user-exported headers, and make the code look more similar again.

> I could also see some sporadic use of u_int32_t - dunno where it comes from.
> But looks wrong to me.

I think it's an old BSDism.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

