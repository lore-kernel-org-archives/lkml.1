Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbYDVAGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYDVAGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbYDVAGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:06:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60505
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757564AbYDVAGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:06:39 -0400
Date: Mon, 21 Apr 2008 17:06:40 -0700 (PDT)
Message-Id: <20080421.170640.181023820.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0804211608570.2779@woody.linux-foundation.org>
References: <20080421.153231.108090227.davem@davemloft.net>
	<alpine.LFD.1.10.0804211608570.2779@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Apr 2008 16:10:00 -0700 (PDT)

> Hmm. I think this is sad. The fact is, Solaris/SunOS is the de-facto 
> standard for Sparc. Which makes me think that not emulating them is a real 
> capability loss. 

There is no capability loss, the code we have hasn't worked on
anything other than extremely trivial Solaris cases, and that's
when it was working.

Nobody has tested or tried to use it at all for years, and as a result
even something as simple as a modern compiled Solaris binary doing:

	int main(void) { return 0; }

won't even work because things the dynamic linker does are
unsupported.

It's not like I've removed the capability for people to run something
like Oracle/Solaris under Linux, nothing even half-way approaching
that ever worked, and so I just wanted to make that clear :-)
