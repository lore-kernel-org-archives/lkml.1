Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZDOPGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZDOPGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZDOPGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:06:25 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:39129 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZDOPGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:06:24 -0400
Date: Wed, 15 Apr 2009 09:07:06 -0600
From: dann frazier <dannf@hp.com>
To: Corey Minyard <minyard@acm.org>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Openipmi-developer] [PATCH 4/5] IPMI: Add console oops catcher
Message-ID: <20090415150706.GQ8345@ldl.fc.hp.com>
References: <20090303152123.GD7777@minyard.local> <20090303132046.a8975963.akpm@linux-foundation.org> <49ADC559.7040705@ct.jp.nec.com> <20090402141445.3a7a6504.akpm@linux-foundation.org> <49E58168.3090409@ct.jp.nec.com> <49E5F07E.40704@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E5F07E.40704@acm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 09:34:38AM -0500, Corey Minyard wrote:
> Hiroshi Shimamoto wrote:
> > Andrew Morton wrote:
> >> On Tue, 03 Mar 2009 16:03:37 -0800
> >> Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> >>
> >>> ...
> >>>> This reader is unable to determine what the mystery preempt_disable()
> >>>> is here for.  It needs a comment, please.
> >>> I cannot recall why it's here. So a comment is really needed.
> >>> This preempt_disable() may not be needed.
> >>>
> >>>> What happens if two CPUs oops at the same time (which is fairly 
> >>>> common)?
> >>> ...
> >>>
> >>> OK. I'll look at this.
> >>>
> >>>> It would be prudent to have a timeout in this loop.  The machine has
> >>>> crashed and subsystems and hardware and memory are in an unknown and
> >>>> possibly bad state.
> >>> Right.
> >>>
> >>> ...
> >>>
> >>>> This looks like we're abusing the "unblank" method.
> >>>>
> >>>> If you think that the console subsystem is missing some capability
> >>>> which this driver needs then please do prefer to fix the console
> >>>> subsystem, rather than awkwardly making things fit.
> >>> OK. Will take a look about this point.
> >>>
> >>
> >> None of this happened.
> >>
> >> It makes me reluctant to merge that patches as they stand, because then
> >> it all gets forgotten about, whereas holding the patches back will
> >> remind us that updates are needed.
> >
> > Sorry for late reply.
> > I couldn't have time for this patch.
> > I'll look at this again and will resend updates.
> Andrew, can we drop this for now and at get the other patches in?  At 
> least the first one ("Fix platform return check"), since it's an obvious 
> bug fix.

As it should allow us stop shipping a set of forked modules,
ipmi-add-oem-message-handling.patch would be nice too :)

> 
> Thanks,
> 
> -corey
> 
> >
> > Thanks,
> > Hiroshi
> >
> 
> 
> ------------------------------------------------------------------------------
> This SF.net email is sponsored by:
> High Quality Requirements in a Collaborative Environment.
> Download a free trial of Rational Requirements Composer Now!
> http://p.sf.net/sfu/www-ibm-com
> _______________________________________________
> Openipmi-developer mailing list
> Openipmi-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/openipmi-developer
> 

-- 
dann frazier

