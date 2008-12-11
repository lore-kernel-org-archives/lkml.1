Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbYLKRGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbYLKRGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 12:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbYLKRF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 12:05:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756841AbYLKRF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 12:05:57 -0500
Date: Thu, 11 Dec 2008 09:05:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Frans Pop <elendil@planet.nl>, Eric Anholt <eric@anholt.net>,
       nix.or.die@googlemail.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Linux 2.6.28-rc8
In-Reply-To: <20081211163548.GA11859@elte.hu>
Message-ID: <alpine.LFD.2.00.0812110902450.3340@localhost.localdomain>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <49407CE1.9090600@googlemail.com> <49407CE1.9090600@googlemail.com> <1228979963.3254.8.camel@gaiman.anholt.net> <200812111707.20857.elendil@planet.nl> <alpine.LFD.2.00.0812110814360.3340@localhost.localdomain>
 <20081211163548.GA11859@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Dec 2008, Ingo Molnar wrote:
> 
> hm, the warning caught a couple of real bugs already. (one in some cpq 
> driver, another was in some networking driver iirc)

Well, one thing that does irritate me is that it scares people who can't 
do anything about it, and probably _shouldn't_ do anything about it.

I wonder if we should just change the "Warning" message to "Informational" 
or something. Yes, they are often real bugs. But no, they're not 
_automatically_ bugs. Almost all the time when a warning triggers, it's 
really just a developer who wants to know about it, it's not something 
that a user should really care/worry about.

			Linus
