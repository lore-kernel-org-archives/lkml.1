Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223Ab0AWHAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab0AWHAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 02:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244Ab0AWHAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 02:00:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40847 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab0AWHAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 02:00:23 -0500
Date: Sat, 23 Jan 2010 07:59:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, tglx@linutronix.de,
       andreas.herrmann3@amd.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3 0/5] x86, cacheinfo, amd: L3 Cache Index Disable fixes
Message-ID: <20100123065953.GB15774@elte.hu>
References: <1264172467-25155-1-git-send-email-bp@amd64.org>
 <4B59DF4C.7040608@zytor.com>
 <20100122174049.GC19425@aftab>
 <4B59E507.9060403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B59E507.9060403@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 01/22/2010 09:40 AM, Borislav Petkov wrote:
> >>>
> >>> Those patches are also good -stable candidates.
> >>
> >> Hmmm... I'm not sure I see a strong justification for a late -rc push
> >> into Linus/stable push for for these... I think you would have to
> >> explicitly make the case if you want them to be considered as such.
> > 
> > Well, on the one hand, they fix real bugs in the L3 cache index disable 
> > code and since they're bugfixes, they are eligible late -rc candidates.
> 
> Bugfixes are *early* -rc candidates.  Regression fixes are *late* -rc 
> candidates, at least that seems to be the policy Linus currently implements.  
> -stable seems to use slightly less strict criteria (the whole point is that 
> -final needs to be a stabilization point, backported fixes/drivers can then 
> come onto a stable base) which is why you seem some patches which are 
> "straight to .1".

Yes.

	Ingo
