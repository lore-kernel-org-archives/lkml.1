Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbXL1WNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbXL1WNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 17:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXL1WNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 17:13:36 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48177 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbXL1WNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 17:13:36 -0500
Date: Sat, 29 Dec 2007 00:13:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Message-ID: <20071228221324.GA9105@does.not.exist>
References: <20071228212341.GA6939@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071228212341.GA6939@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 10:23:41PM +0100, Sam Ravnborg wrote:
>...
> Noteworthy remarks on the unification:
>...
> - -funit-at-a-time should be easy to unify but it looks like we have a bug
>   in 32 bit. We only enable -funit-at-a-time for gcc less than 0400 if they
>   support it

No, we _dis_able it on 32bit if a gcc < 4.0 supports it.

> (and I recall it is a gcc 4.00 feature). [-lt -> -gt]
>...

unit-at-a-time was introduced in upstream gcc 3.4 and backported to some 
popular 3.3 x86_64 branch.

i386 and x86_64 go in exactly opposite directions regarding when to use 
unit-at-a-time, but that was intentional and we should keep it that way.

> 	Sam
>...


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

