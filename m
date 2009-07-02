Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZGBGqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZGBGqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZGBGqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:46:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47905 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZGBGqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:46:16 -0400
Date: Thu, 2 Jul 2009 08:46:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org
Subject: Re: [BUG] MIPS: Hibernation in the latest linux-mips:master branch
	not work
Message-ID: <20090702064612.GB18157@elf.ucw.cz>
References: <1246372868.19049.17.camel@falcon> <20090630144540.GA18212@linux-mips.org> <1246374687.20482.10.camel@falcon> <20090701180715.GA23121@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701180715.GA23121@linux-mips.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-01 19:07:15, Ralf Baechle wrote:
> On Tue, Jun 30, 2009 at 11:11:27PM +0800, Wu Zhangjin wrote:
> 
> > hi, ralf, in the latest master branch of linux-mips git repo, seems
> > there is a need to select the SYS_SUPPORTS_HOTPLUG_CPU option in every
> > uni-processor board, otherwise, the suspend/hibernation can not be used,
> > because you have set:
> > 
> > config ARCH_HIBERNATION_POSSIBLE
> >     def_bool y
> >     depends on SYS_SUPPORTS_HOTPLUG_CPU
> > 
> > config ARCH_SUSPEND_POSSIBLE
> >     def_bool y
> >     depends on SYS_SUPPORTS_HOTPLUG_CPU
> > 
> > so, the board-specific patch must be pushed by the maintainers of
> > boards. and if the board support SMP, they must implement the
> > mips-specific hotplug support, is this right? I have selected
> > SYS_SUPPORTS_HOTPLUG_CPU in LEMOTE_FULONG and will push a relative patch
> > later.
> 
> I think below patch should take care of this problem.  It simply assumes
> that all uniprocessor systems support suspend and hibernate.  That's an
> assumption that I'm not to unhappy with though it may force us to fix a
> few systems.
> 
>   Ralf
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
