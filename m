Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403Ab0AMBAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab0AMBAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430Ab0AMBAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:00:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977Ab0AMBAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:00:00 -0500
Date: Tue, 12 Jan 2010 16:59:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86-32: clean up rwsem inline asm statements
In-Reply-To: <4B4D1865.5000107@zytor.com>
Message-ID: <alpine.LFD.2.00.1001121659220.17145@localhost.localdomain>
References: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain> <4B4D1865.5000107@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Jan 2010, H. Peter Anvin wrote:
> 
> As far as I can tell, very few of these assembly statements actually
> need a size at all -- the very first inc statement is purely to memory,
> and as such it needs a size marker, but almost any operation which is
> register-register or register-memory will simply take its size from the
> register operand.  For those, it seems cleaner to simply drop the size
> suffix, and in fact this is the style we have been pushing people
> towards (use the suffix where mandatory or where the size is fixed
> anyway, to help catch bugs; use no suffix where the size can vary and is
> implied by the operands.)
> 
> So, proposed alternate version of your patch attached.

Looks good to me.

		Linus
