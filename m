Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZA0XaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZA0XaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZA0X36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:29:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbZA0X35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:29:57 -0500
Date: Tue, 27 Jan 2009 15:29:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
In-Reply-To: <497F9740.4000505@zytor.com>
Message-ID: <alpine.LFD.2.00.0901271527340.3123@localhost.localdomain>
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain> <497F9740.4000505@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Jan 2009, H. Peter Anvin wrote:
>
> The intent of headers_check is to try to catch people who put things that
> depend on CONFIG_* stuff in exported headers (which, as we have seen, have
> been too sadly common.)  If we declare that the export process will treat all
> CONFIG_* as undefined, we do lose some coverage but potentially end up with
> cleaner code.  Not sure which is worse...

Do you think the "fix headers_check" patches spend lots of time analyzing 
things? I bet no. They just try to make the warning go away, so you don't 
actually end up with any more "coverage" anyway. Quite the reverse - 
instead of having a simple rule ("CONFIG_xyz options simply do not exist 
in user space"), you end up having ad-hoc hacks on a per-fix basis.

		Linus
