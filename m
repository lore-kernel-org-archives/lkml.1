Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0BOGjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:39:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57073 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab0BOGjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:39:20 -0500
Date: Sun, 14 Feb 2010 22:39:16 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Bret Towe <magnade@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: reiserfs issue with 2.6.32.8
In-Reply-To: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1002142229470.28195@bogon.housecafe.de>
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/R6MVLZ2cXzkZVhIeGfaEcrARJfTt9MWPC8rJ
 VYktseXl81p5AXf2Ljvug4PaTtowb95h0JLzGZe5g+YzVBagmU
 pn+WYNXgAGbgJqWIH2W7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Feb 2010 at 10:23, Bret Towe wrote:
> I recently attempted upgrading from 2.6.31.6 to 2.6.32.8 on a local server
> that runs several filesystems and when trying to move or copy or create a file
> on a reiserfs system that was sitting on lvm over raid5(not sure if
> that matters)
> I would get mv or cp to return Invalid Argument and not doing anything
> moving files from xfs to xfs worked fine tho

I'm running 2.6.32 (and now 2.6.33) with reiserfs filesystems too and 
cannot reproduce what you're seeing. Can you run mv/cp through strace and 
provide the output? Also, if you can: maybe setting REISERFS_CHECK in your 
kernel config might reveal something useful.

Is this reproducible with 2.6.33-rcX as well? If so, I'd recommend to try 
again with plain 2.6.32 and if it's still there, I see no other way to 
narrow it down but with a git bisection (man git-bisect).

Christian.
-- 
BOFH excuse #216:

What office are you in? Oh, that one.  Did you know that your building was built over the universities first nuclear research site? And wow, aren't you the lucky one, your office is right over where the core is buried!
