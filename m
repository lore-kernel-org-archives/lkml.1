Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164Ab0AWILk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0AWILk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 03:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697Ab0AWILj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 03:11:39 -0500
Received: from mail-ew0-f226.google.com ([209.85.219.226]:57619 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0AWILj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 03:11:39 -0500
X-Greylist: delayed 759 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jan 2010 03:11:38 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Lxm45J3Id+DBUga3UwNMvsDb1jHj3EZfM/e6xki8wUMwgsGFNbHvMcxHaMOis1mZhV
         cxvGSnHePr32DwyWi6wtKnGP0ezd5At1UpASpv9IsayQ/A1obs7LtA9ULDrw/eq4qPeW
         COu7jGru4nlo0vXZNvpV+OJ4ZW3OYHHTplUfk=
Date: Sat, 23 Jan 2010 09:11:32 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
       tglx@linutronix.de, andreas.herrmann3@amd.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3 0/5] x86, cacheinfo, amd: L3 Cache Index Disable
 fixes
Message-ID: <20100123081132.GB7098@liondog.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100123065953.GB15774@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 07:59:53AM +0100, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 01/22/2010 09:40 AM, Borislav Petkov wrote:
> > >>>
> > >>> Those patches are also good -stable candidates.
> > >>
> > >> Hmmm... I'm not sure I see a strong justification for a late -rc push
> > >> into Linus/stable push for for these... I think you would have to
> > >> explicitly make the case if you want them to be considered as such.
> > > 
> > > Well, on the one hand, they fix real bugs in the L3 cache index disable 
> > > code and since they're bugfixes, they are eligible late -rc candidates.
> > 
> > Bugfixes are *early* -rc candidates.  Regression fixes are *late* -rc 
> > candidates, at least that seems to be the policy Linus currently implements.  
> > -stable seems to use slightly less strict criteria (the whole point is that 
> > -final needs to be a stabilization point, backported fixes/drivers can then 
> > come onto a stable base) which is why you seem some patches which are 
> > "straight to .1".
> 
> Yes.

Ok, thanks for the clarification - my only trouble was that the current
code is b0rked as is and those fixes are needed. However, backporting
them at a later point seems much more riskfree and I will do so later.

Thanks.

-- 
Regards/Gruss,
    Boris.
