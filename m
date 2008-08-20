Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbYHTTYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbYHTTYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYHTTYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:24:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47486 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbYHTTYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:24:30 -0400
Date: Wed, 20 Aug 2008 21:25:41 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Uros Bizjak <ubizjak@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] x86: Use X86_CR4_PGE in x86/power/hibernate_asm_32.S
Message-ID: <20080820192541.GA2134@elf.ucw.cz>
References: <5787cf470808200144ta2f28b4nd9b2922cbec73d78@mail.gmail.com> <20080820095353.GB28492@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820095353.GB28492@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-08-20 11:53:53, Ingo Molnar wrote:
> 
> * Uros Bizjak <ubizjak@gmail.com> wrote:
> 
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> 
> applied the commit below to tip/x86/cleanups - thanks Uros.
> 
> i did a small change: i moved the .text to after the include files. 
> While include files are not supposed to change section attributes, it 
> looks logically more consistent to have the .text right before the code.
> 
> 	Ingo
> 
> ----------------->
> >From c171f465b7281f2d3b03e9145ec763d6a8bab176 Mon Sep 17 00:00:00 2001
> From: Uros Bizjak <ubizjak@gmail.com>
> Date: Wed, 20 Aug 2008 10:44:47 +0200
> Subject: [PATCH] x86, cleanup: use X86_CR4_PGE in x86/power/hibernate_asm_32.S
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
