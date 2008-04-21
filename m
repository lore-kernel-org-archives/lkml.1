Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbYDUXKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbYDUXKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYDUXKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:10:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374AbYDUXKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:10:31 -0400
Date: Mon, 21 Apr 2008 16:10:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [GIT]: Sparc
In-Reply-To: <20080421.153231.108090227.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0804211608570.2779@woody.linux-foundation.org>
References: <20080421.153231.108090227.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Apr 2008, David Miller wrote:
> 
> This performs the scheduled removal of Solaris and SunOS
> system call for sparc, much to the chagrin of Al Viro
> and others :-) (in particular, that asm/namei.h crud can
> now die)

Hmm. I think this is sad. The fact is, Solaris/SunOS is the de-facto 
standard for Sparc. Which makes me think that not emulating them is a real 
capability loss. 

I realize that the code may be painful, but still...

		Linus
