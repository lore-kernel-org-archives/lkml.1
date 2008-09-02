Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbYIBMIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbYIBMIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 08:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYIBMI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 08:08:29 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:14019 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYIBMI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 08:08:28 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Date: Tue, 2 Sep 2008 08:08:22 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <200809011623.12518.linux@sandersweb.net> <alpine.LFD.1.10.0809011521270.12958@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809011521270.12958@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809020808.23131.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2008 18:22, Linus Torvalds wrote:
> On Mon, 1 Sep 2008, David Sanders wrote:
> > OK, below is my patch.  The problem is I just built with it and the boot
> > problem still exists.  Either the patch is flawed or git-bisect gave me
> > the wrong commit.  Any help would be appreciated.
>
> Try just reverting the commit that you bisected to, and double-check. If
> your bisect was flawed, there's no point even staring at the nop code ;)
>
> 		Linus

Thanks Linus.
I reverted the commit and the problem persits, so nops are definitely not the 
problem.  I started an new bisection but am now in a state that won't compile 
due to errors.  What do I do in that case?
David
