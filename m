Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbYFDARy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbYFDARy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYFDARq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:17:46 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:18624 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752771AbYFDARq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:17:46 -0400
Date: Wed, 4 Jun 2008 04:17:39 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: galak@kernel.crashing.org, wim@iguana.be, jochen@scram.de,
       sfr@canb.auug.org.au, segher@kernel.crashing.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8 v4] mpc83xx_wdt rework, support for mpc8610 and
	mpc8xx
Message-ID: <20080604001739.GB24548@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080602173726.GA24556@polina.dev.rtsoft.ru> <20080603164830.32457962.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080603164830.32457962.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 04:48:30PM -0700, Andrew Morton wrote:
> On Mon, 2 Jun 2008 21:37:26 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > No comments on the previous version for two weeks... resending once
> > again.
> 
> I did all the rework to make the patches apply on top of all the
> pending watchdog work in Wim's tree and in -mm.  I haven't build tested
> it yet.

Thanks, I'll test it in run-time also.

> I'll assume that
> 
>  [PATCH 7/8] [POWERPC] fsl_soc: remove mpc83xx_wdt code
> 
> and
> 
>  [PATCH 8/8] [POWERPC] 86xx: mpc8610_hpcd: add watchdog node
> 
> are dependent upon the preceding six patches.  This might be wrong.

This is correct.

> Please put the subsystem identifier (eg, "watchdog" and "powerpc")
> outside the [], for reasons which should be in
> Documentation/SubmittingPatches, which used to be there but which got
> lost.  Bascially the text inside [] is for temporary not-for-committing
> information such as "rfc", "2.6.24-rc4", "resend", etc and should be stripped
> by the email recipient before merging.

Yeah, I know. It is just hard to remember all the preferences.

For example, PowerPC maintainers asking to do patches with "[POWERPC]"
identifier, this identifier purposely keeps intact for git-log.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
