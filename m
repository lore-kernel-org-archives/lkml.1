Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbZJGVou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbZJGVou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZJGVot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:44:49 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:53597 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbZJGVos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mbttuUGkzxmpBOn4BuNkMoAlEXpKkYTNBEBU19IWyCVwvkvOAccmtnIKGJhmVw4LtH
         ASs3dnaERPGRgJcqbcFXUXlbURdThfe8X6kJD6WR2KBW+DJPqKOjJ+owYNUdVmHLJk+Y
         AQjtPU/lbnOvA/vm1/GLbr1GseXE+WEHWt7Tw=
Date: Wed, 7 Oct 2009 23:44:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH RFC] BKL not necessary in cpuid_open
Message-ID: <20091007214408.GF5903@nowhere>
References: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain> <20091007201338.GE5903@nowhere> <alpine.LFD.2.00.0910072259230.9428@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910072259230.9428@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 11:01:23PM +0200, Thomas Gleixner wrote:
> On Wed, 7 Oct 2009, Frederic Weisbecker wrote:
> > Hmm, I'm discovering that in tip:rt/kill-the-bkl
> > 
> > http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commitdiff;h=55968ede164ae523692f00717f50cd926f1382a0
> > 
> > Looks like we have overlaped.
> > 
> > Thomas it would be nice to post these patches on LKML (or I missed
> > them?) and may be to merge them into tip:master, so that they are
> > visible and then we lower the risk of any duplicate works in this area.
> 
> Now guess why I mentioned this branch sevaral times at the rt summit
> last week. It's even documented in Jonathans excellent meeting
> minutes on lwn.net :)
> 
> Thanks,
> 
> 	tglx



Yeah, but you know, I very good when it comes to find/remember
something obvious only right after posting a patch (I rarely
posted a patch not followed by a v2 lately). A kind of
post-posting only memory, something that becomes common with me,
I guess I need to start learning how to live with it :)

That said, some developers who don't read lwn (or other kind of
people gifted by the post-patch-posting memory power) may come and try
to remove the bkl there, since it's not visible in lkml archives
or in the master branch of the x86 tree.

Ah, for example hpa has just committed my patch :-)



