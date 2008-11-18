Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbYKRAYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbYKRAYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYKRAYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:24:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbYKRAYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:24:45 -0500
Date: Mon, 17 Nov 2008 16:23:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jikos@jikos.cz>
Subject: Re: 2.6.28-rc4-mmotm1110 shift-lock oddness
Message-Id: <20081117162350.82b2806b.akpm@linux-foundation.org>
In-Reply-To: <5397.1226959015@turing-police.cc.vt.edu>
References: <5397.1226959015@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 16:56:55 -0500 Valdis.Kletnieks@vt.edu wrote:

> Twice today, I've managed to get my laptop into an odd state where the keyboard
> got quite confused:
> 
> 1) For the characters [a-z] the shift bit was *inverted* - if the shift-lock
> LED was off, you'd get UPPER-case, and if it was on, you'd get lower-case.
> 
> 2) To add to the fun, the 0-9 keys were stuck shifted - I'd get the special
> characters no matter what setting the shift or shift-lock key had.  I suspect
> that the special-char keys like [{ and ;: were also stuck in shifted state,
> but can't totally confirm it.
> 
> The previous two issues combined meant that I wasn't able to su or login
> as root to do much of anything about it (guess who has special chars in their
> root password? ;)
> 
> 3) ctl-alt-Fn to switch virtual consoles was spotty/erratic - one time
> I was unable to use it at all, another time I was able to use c-a-F1 to get
> to a green-screen console, but then F2 to get another one or F7 to get
> back to the X server screen wouldn't work.
> 
> 4) Fortunately for my sanity, alt-sysrq was still working as advertised,
> so I was able to reboot and thus clear the problem.
> 
> I was thinking this might be a simple "missed a key press/released" event
> for a shift key, except that doesn't explain the numerics getting stuck shifted.
> 
> Any suggestions/hints for instrumentation/etc, in case I can replicate it
> again?

That's the first such report I've seen.  Let's add some cc's.
