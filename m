Return-Path: <linux-kernel-owner+w=401wt.eu-S1767064AbXDTMHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767064AbXDTMHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 08:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767069AbXDTMHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 08:07:16 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56674 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767066AbXDTMHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 08:07:14 -0400
Date: Fri, 20 Apr 2007 14:07:20 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: chris@pcburn.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: GPL-incompatible Module Error Message
Message-ID: <20070420120720.GW10338@stusta.de>
References: <4627EED5.6020800@pcburn.com> <p73vefr4y1c.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <p73vefr4y1c.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 03:47:27AM +0200, Andi Kleen wrote:
> Chris Bergeron <chris@pcburn.com> writes:
> 
> > Hello all,
> > 
> > Building the fglrx module against the current Linux kernel (2.6.20.7
> > as of this e-mail) I'm getting an error:
> > 
> > FATAL: modpost: GPL-incompatible module fglrx.ko uses GPL-only symbol
> > 'paravirt_ops'
> 
> It should probably be available for non GPL modules too. Otherwise
> they can't even disable interrupts, which seems a bit extreme.
> I will change that in my tree.

Don't do this, this would allow non-GPL modules write access to 
paravirt_ops.

Operations required by modules should be exported separately.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

