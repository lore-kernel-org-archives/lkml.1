Return-Path: <linux-kernel-owner+w=401wt.eu-S1751284AbYFDEHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbYFDEHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYFDEHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:07:32 -0400
Received: from ozlabs.org ([203.10.76.45]:55729 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbYFDEH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:07:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18502.5368.786188.835122@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jun 2008 14:07:20 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: avorontsov@ru.mvista.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, wim@iguana.be,
       scottwood@freescale.com
Subject: Re: [PATCH 0/8 v4] mpc83xx_wdt rework, support for mpc8610 and mpc8xx
In-Reply-To: <20080603173214.0bf71571.akpm@linux-foundation.org>
References: <20080602173726.GA24556@polina.dev.rtsoft.ru>
	<20080603164830.32457962.akpm@linux-foundation.org>
	<20080604001739.GB24548@polina.dev.rtsoft.ru>
	<20080603173214.0bf71571.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> On Wed, 4 Jun 2008 04:17:39 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > > Please put the subsystem identifier (eg, "watchdog" and "powerpc")
> > > outside the [], for reasons which should be in
> > > Documentation/SubmittingPatches, which used to be there but which got
> > > lost.  Bascially the text inside [] is for temporary not-for-committing
> > > information such as "rfc", "2.6.24-rc4", "resend", etc and should be stripped
> > > by the email recipient before merging.
> > 
> > Yeah, I know. It is just hard to remember all the preferences.
> > 
> > For example, PowerPC maintainers asking to do patches with "[POWERPC]"
> > identifier, this identifier purposely keeps intact for git-log.
> 
> Addition of "[powerpc]" if it was absent can be scripted.
> 
> However, the retaining of "[powerpc]" (etc) while not retaining "[rfc]"
> (etc) is not practical.
> 
> Plus putting things into git with "[powerpc]" in the title is wrong. 
> The chances are good that anyone who is taking such a patch off the
> git-commits list (say, for a backport) will lose that part of the
> title.  It should be "powerpc: "

I think Anton is confusing two things: (a) what should be in the
subject line of a patch posted to a mailing list, and (b) what should
be in the headline of a commit put into a git tree that I pull from.
As for (a), people can put whatever they like in [], and if people put
"powerpc:" in the subject, I edit it out since my scripts put
[POWERPC] in the git commit headline.  For (b), I ask git tree
maintainers that I'm going to pull from to put [POWERPC] at the start
of the headline for consistency with what I do.

Looking at Linus' git tree, it's evident that some subsystems use the
the "[SUBSYSTEM]" notation and some use "subsystem:".  If there is now
an edict from on high that only "subsystem:" is acceptable, then I
must have missed that memo.

Paul.
