Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbYAJPMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbYAJPMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761555AbYAJPKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:10:00 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:33180 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761552AbYAJPJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:09:59 -0500
Date: Thu, 10 Jan 2008 17:09:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080110150911.GG28740@does.not.exist>
References: <20080103442.621670000@suse.de> <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <p73fxx5omck.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 02:12:59PM +0100, Andi Kleen wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> >
> > Technically you are the one who has to deal with problems in your 
> > patches, not the people pointing at the problems.
> 
> If you believe that my patch adds a new problem then please describe
> it clearly so that I can understand it.

Description:
- there are already __cpuinit* annotations in the kernel
- on UP kernels supporting suspend/resume, such annotated code
  currently gets freed after booting (and this works)
- with your patch applied, this code no longer gets freed

Whether or not this is a problem depends on whether you care about the 
memory used by the kernel or not...

My other issues with your patch were:
- whatever warning this patch was supposed to fixed was not shown
  (the patch description didn't mention any warning at all) - and
  understanding a fix gets easier when you know the problem it's
  supposed to fix
- this patch shouldn't be x86 specific since the issue how to 
  annotate suspend and CPU hotplug code isn't x86 specific

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

