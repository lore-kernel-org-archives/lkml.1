Return-Path: <linux-kernel-owner+w=401wt.eu-S1758816AbYFJIhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbYFJIhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 04:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYFJIhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 04:37:09 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:58878 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbYFJIhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 04:37:07 -0400
Date: Tue, 10 Jun 2008 11:36:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Rob Landley <rob@landley.net>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: mainlining min-configs...
Message-ID: <20080610083610.GC1987@cs181133002.pp.htv.fi>
References: <48447615.5050806@am.sony.com> <20080604194002.GF4189@cs181133002.pp.htv.fi> <4849CCA3.7040102@am.sony.com> <200806062329.54019.rob@landley.net> <484DDAD9.2000306@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <484DDAD9.2000306@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 06:37:29PM -0700, Tim Bird wrote:
> Rob Landley wrote:
> > On Friday 06 June 2008 18:47:47 Tim Bird wrote:
> >> At a minimum, it would be nice to have a few nice examples
> >> of really, really small configs for things like qemus for different
> >> architectures (just to give embedded developers who are working
> >> on size a starting point).
> > 
> > That's more or less what I'm trying to do with my Firmware Linux project: 
> > creating cross compilers and minimal native build environments for every qemu 
> > target.
> 
> Any chance of getting your minimal configs from Firmware Linux mainlined?

It could help finding compile errors in some more "exotic" configurations
early (but I'd question whether the Rob's current configs are really 
both minimal and typical for embedded usage - e.g the i686 one having 
both ext2 and ext3 enabled but no JFFS2; and enabling all IO schedulers 
in the kernel as well as ACPI is also not a typical embedded setup).

But if you want to discover size change with minimal configs early you 
anyway have to both:
- constantly keep your configs in shape so that they are both minimal
  for some set of hardware support and features and
- investigate for any size changes what caused them
  (experience has shown that putting information on a webpage doesn't
   fix problems - even for compile errors).

You need both, and ideally constantly done by the same person against 
Linus' tree, -next and -mm.

Where to get your minimal configs from at the start is just a small 
thing at the beginning - don't underestimate the required manual work 
that will have to be done each week.

> Does anyone else think this would be valuable?  If not in mainline, it
> would be nice to collect them somewhere, to compare what options different
> developers decide turn on or off.

You already have this when you look at e.g. the ARM defconfigs in the 
kernel

>  -- Tim

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

