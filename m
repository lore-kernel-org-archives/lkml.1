Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZCMKIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZCMKIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbZCMKIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:08:13 -0400
Received: from ns2.suse.de ([195.135.220.15]:53322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZCMKIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:08:13 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: How to submit patches that should be considered for stable inclusion also [Was: Re: [PATCH v2] x86: mtrr: ...]
Date: Fri, 13 Mar 2009 11:08:07 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.15-SLE11_BRANCH_20090211224354_e2f9ae3b-default; KDE/4.1.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>,
       "Greg Kroah-Hartman" <gregkh@novell.com>
References: <20090311150027.GK10490@alberich.amd.com> <200903130942.38568.trenn@suse.de> <20090313091812.GB2571@elte.hu>
In-Reply-To: <20090313091812.GB2571@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903131108.08619.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009 10:18:12 Ingo Molnar wrote:
> 
> * Thomas Renninger <trenn@suse.de> wrote:
> 
> > What does -stable backport tag mean?
> 
> It means such lines added to commit logs:
> 
>     Cc: <stable@kernel.org>
Thanks. That was the bit I liked to know.
> 
> Pointing out specific examples where the backport was realized 
> when the fix was committed but the tag was not added or outright 
> lost, and talking to those those maintainers might help. Often 
> it's a matter of "Oh, cool, did not know that!" realization.
Yep. Same for me.
> 
> Interestingly, the second-ever such tag i found in Git history 
> was for a fix ... from you:
I did this more intuitively.
If this is how it should be done, this info should be spread
to maintainers and repeated some times until really everybody
is looking at it. This is not much work. The backporting itself
might be, but this could be done by the author or distributions looking out 
for that tag. At least much less important "easy" fixes shouldn't slip 
through or take a long time until someone realizes that they are missing.

Thanks,

     Thomas
