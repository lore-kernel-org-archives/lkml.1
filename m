Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYG2VpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYG2VpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYG2VpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:45:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894AbYG2VpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:45:05 -0400
Date: Tue, 29 Jul 2008 14:42:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.27-rc1
In-Reply-To: <20080729213746.GA22548@uranus.ravnborg.org>
Message-ID: <alpine.LFD.1.10.0807291439270.3334@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <20080729213746.GA22548@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Jul 2008, Sam Ravnborg wrote:
> 
> But will you accept this stuff now or will we have to wait until
> next merge window?

if the patches are really small adn the resulting build is well tested 
(ignoring the actual _move_ operation), I'm ok with taking them.

In fact, in many ways I'd _prefer_ to do it now, rather than have it 
pending and then do it durign the next merge window when there are a lot 
of non-movement changes too.

> Now is a good time as development just started for next kernel.
> And testing is simple - does it build?

Well, simple and simple. I'd love to see x86 done, but you yourself said 
you haven't even dared look at UM. Which is the thing that is most likely 
to have odd build things with direct symlinks etc.

(But I haven't looked either. Maybe I'm wrong, and it's all trivial).

		Linus
