Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbYIAWXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbYIAWXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 18:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYIAWXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 18:23:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbYIAWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 18:23:07 -0400
Date: Mon, 1 Sep 2008 15:22:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Sanders <linux@sandersweb.net>
cc: linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <200809011623.12518.linux@sandersweb.net>
Message-ID: <alpine.LFD.1.10.0809011521270.12958@nehalem.linux-foundation.org>
References: <200808311422.12525.linux@sandersweb.net> <alpine.LFD.1.10.0808311140060.12958@nehalem.linux-foundation.org> <200808311603.49056.linux@sandersweb.net> <200809011623.12518.linux@sandersweb.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Sep 2008, David Sanders wrote:
> 
> OK, below is my patch.  The problem is I just built with it and the boot 
> problem still exists.  Either the patch is flawed or git-bisect gave me the 
> wrong commit.  Any help would be appreciated.

Try just reverting the commit that you bisected to, and double-check. If 
your bisect was flawed, there's no point even staring at the nop code ;)

		Linus
