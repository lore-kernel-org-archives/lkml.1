Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028Ab0AWQce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0AWQce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 11:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799Ab0AWQcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 11:32:32 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50452 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab0AWQca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 11:32:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=cB4CXB8qLhd0G/M+JTkwJHRWe+IdXBDwrHmATryb72xFupasbaa4khF6aVtMAxkzx2
         n1jIZI7t86MRRC9gMYlj5TnMqrmoysDvw83Bwu5T1jpWmnoSJj/CLMPtJ6T0KMIgkyRr
         NC9DmgyzfuJgh1kuJkfiEZ09+66dQit7YBaTY=
Date: Sat, 23 Jan 2010 17:32:23 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
       tglx@linutronix.de, andreas.herrmann3@amd.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3 0/5] x86, cacheinfo, amd: L3 Cache Index Disable
 fixes
Message-ID: <20100123163223.GA30859@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Borislav Petkov <bp@amd64.org>, tglx@linutronix.de,
	andreas.herrmann3@amd.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1264172467-25155-1-git-send-email-bp@amd64.org>
 <4B59DF4C.7040608@zytor.com>
 <20100122174049.GC19425@aftab>
 <4B59E507.9060403@zytor.com>
 <20100123065953.GB15774@elte.hu>
 <20100123081132.GB7098@liondog.tnic>
 <20100123090135.GB20056@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100123090135.GB20056@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 10:01:35AM +0100, Ingo Molnar wrote:
> 
> * Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
> > On Sat, Jan 23, 2010 at 07:59:53AM +0100, Ingo Molnar wrote:
> > > 
> > > * H. Peter Anvin <hpa@zytor.com> wrote:
> > > 
> > > > On 01/22/2010 09:40 AM, Borislav Petkov wrote:
> > > > >>>
> > > > >>> Those patches are also good -stable candidates.
> > > > >>
> > > > >> Hmmm... I'm not sure I see a strong justification for a late -rc push
> > > > >> into Linus/stable push for for these... I think you would have to
> > > > >> explicitly make the case if you want them to be considered as such.
> > > > > 
> > > > > Well, on the one hand, they fix real bugs in the L3 cache index disable 
> > > > > code and since they're bugfixes, they are eligible late -rc candidates.
> > > > 
> > > > Bugfixes are *early* -rc candidates.  Regression fixes are *late* -rc 
> > > > candidates, at least that seems to be the policy Linus currently implements.  
> > > > -stable seems to use slightly less strict criteria (the whole point is that 
> > > > -final needs to be a stabilization point, backported fixes/drivers can then 
> > > > come onto a stable base) which is why you seem some patches which are 
> > > > "straight to .1".
> > > 
> > > Yes.
> > 
> > Ok, thanks for the clarification - my only trouble was that the current
> > code is b0rked as is and those fixes are needed. However, backporting
> > them at a later point seems much more riskfree and I will do so later.
> > 
> > Thanks.
> 
> Well, if there's a crasher in there, then a minimal fix to address just that 
> is preferred for .33 - and that can be tagged for -stable immediately.

As I said earlier, I don't believe we have machines in the wild to
practically support the feature yet so we should be OK without a fix.
Let me verify that next week and get back to you with a minimal fix in
case we have any affected configurations.

Thanks.

-- 
Regards/Gruss,
    Boris.
