Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYL0S7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYL0S7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 13:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYL0S64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 13:58:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58434 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbYL0S6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 13:58:55 -0500
Message-ID: <49567AC3.4030507@zytor.com>
Date: Sat, 27 Dec 2008 10:58:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, Mike Frysinger <vapier@gentoo.org>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <20081227071208.GB27736@uranus.ravnborg.org> <20081227084708.GA16077@elte.hu> <20081227185727.GB10442@uranus.ravnborg.org>
In-Reply-To: <20081227185727.GB10442@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> I wnet with the scripted conversion for now.
> If that does not fly we can come back to this proposal.
> 
> What I like most with the auto conversion is that we avoid
> adding yet another special rule about how to do stuff in exported headers.
> 

Indeed, and being keyword conversion, it's independent of context, at
least as long as one doesn't have too many run-ins with weird uses of
the # and ## preprocessor operators, which are a *lot* easier to rule
out globally.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

