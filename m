Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbYLFKJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbYLFKJm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 05:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYLFKJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 05:09:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54263 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYLFKJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 05:09:31 -0500
Date: Sat, 6 Dec 2008 11:20:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Is vm86old no more implemented?
Message-ID: <20081206102047.GG6703@one.firstfloor.org>
References: <200812061043.51438.arvidjaar@mail.ru> <87y6ytvg0s.fsf@basil.nowhere.org> <200812061252.51173.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200812061252.51173.arvidjaar@mail.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 12:52:43PM +0300, Andrey Borzenkov wrote:
> On Суббота 06 декабря 2008 11:56:03 Andi Kleen wrote:
> > Andrey Borzenkov <arvidjaar@mail.ru> writes:
> > > CONFIG_VM86 is defined; is there anything else that is needed? This fails
> > > both in 2.6.27.7 and in 2.6.28-rc7. I attach config from 2.6.28-rc7.
> >
> > It should still work. Can you double check you're running the correct
> > kernel? Perhaps a 64bit kernel (which doesn't implement it).
> >
> 
> Linux cooker 2.6.28-rc7-1avb #23 Fri Dec 5 22:42:47 MSK 2008 i686 Pentium III 
> (Coppermine) GNU/Linux
> 
> Anything else I can check?

Hmm perhaps place a printk into arch/x86/kernel/vm86_32.c:sys_vm86old()
and see if it's reached.

-Andi

-- 
ak@linux.intel.com
