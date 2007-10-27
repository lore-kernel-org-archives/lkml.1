Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbXJ0FRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbXJ0FRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 01:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbXJ0FRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 01:17:07 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45815 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751656AbXJ0FRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 01:17:05 -0400
Date: Sat, 27 Oct 2007 07:17:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kir@swsoft.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, kir@openvz.org,
       Cedric Le Goater <clg@fr.ibm.com>, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [Devel] [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take 2)
Message-ID: <20071027051724.GR30533@stusta.de>
References: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com> <m1ve8ty1tq.fsf@ebiederm.dsl.xmission.com> <20071027002448.GH30533@stusta.de> <m18x5puyw7.fsf@ebiederm.dsl.xmission.com> <20071027020408.GO30533@stusta.de> <20071026191845.fd0f75c8.akpm@linux-foundation.org> <m18x5pte18.fsf@ebiederm.dsl.xmission.com> <20071027040346.GQ30533@stusta.de> <m14pgdtbkj.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m14pgdtbkj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 10:40:12PM -0600, Eric W. Biederman wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> 
> > There isn't any hard semantics behind what is marked EXPERIMENTAL and 
> > what not. In it's current state, we could even consider removing the 
> > EXPERIMENTAL option and all dependencies on EXPERIMENTAL.
> 
> Well I do know at least some of the things that depend on experimental
> are legitimate.
> 
> I wonder if the problem is that we don't police experimental well
> enough.
> 
> > Currently CONFIG_EXPERIMENTAL=n would cost a distribution a three digit 
> > number of device drivers plus several features like e.g. NFSv4.
> 
> I can see a distribution carefully cherry picking things, that the
> have an intimate knowledge about out of experimental but it doesn't
> sound right for taking things out of EXPERIMENTAL to be routine.
> 
> I know I'm a little slow about getting around to it but when ever I
> have a feature that isn't EXPERIMENTAL anymore I remove the tag.

Part of the picture might be that code that was included into the kernel 
usually is in a state that it works at least most time for most of the 
people.

And when you think about distributions, it's hard to imagine why a 
distribution should not enable more or less all EXPERIMENTAL device 
drivers - an EXPERIMENTAL driver is much better than no driver for this 
hardware at all.

> Eric

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

