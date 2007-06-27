Return-Path: <linux-kernel-owner+w=401wt.eu-S1763159AbXF0TLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763159AbXF0TLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbXF0TLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:11:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:53618 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760781AbXF0TK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ULB3E7kXpMtJzc+fk2mxA7lSnhhbxTlhBmUteAHTWK3EjV/0Qti/bBb0Vm2aiOE1hdfwBune/iPcPRzYfYIazxJbr/JOMw9WYT6K8/lNcmtvcj2mBddYb70mgDWWoYK17HziA4FAqCjbJpahDdo5SVoJnxPL0ydMdvAwbsHH5WQ=
From: Andreas Hartmetz <ahartmetz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Date: Wed, 27 Jun 2007 21:10:50 +0200
User-Agent: KMail/1.9.7
References: <200706271825.17459.ahartmetz@gmail.com> <46829E82.6080804@gmail.com>
In-Reply-To: <46829E82.6080804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706272110.50744.ahartmetz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't like random applications blocking my sound card.
>
> So don't use random applications.
>
I imitated the style of the mail I replied to. Besides, choosing apps based on 
sound system is retarded if you wanted to indicate that this should be done 
more often or something.

> > You are concerned about your precious audio quality? Me too. Most people,
> > however, are using god-awful plastic speakers for twenty euros and shitty
> > onboard sound chips. Sad but true.
>
> Exactly, which is why mixing has been default for some time now for most
> cards. Are you only ranting about how it should've been earlier?
>
Exactly! And the config file is hostile if you want to change it.

> > ALSA appeared in 1999, KDE 2 with aRtsd (another catastrophic failure of
> > technology) was released in october 2000.
>
> http://www.arts-project.org/gen/newsarchive/news_1998.html
>
KDE 2 *was* released in 2000. Why would you care, I already admitted that 
sound daemons were there before ALSA.

> >>  That sounds like a minor glitch that should be easily remedied if you
> >>  file a proper bug report. Have you tried?
> >
> > No, I kinda gave up on ALSA after reading its API (rather "functions
> > that happen to be exported") documentation and kinda hoped it would go
> > away ASAP.
>
> You give up reporting small hardware problems that bother you because the
> application developer documentation for something is not in great shape?

Yep, because I was frustrated with the whole thing. Having huge bad APIs with 
no documentation is telling your fellow developers to piss off and do 
something else. I did.
It's not like a little oversight to be quickly forgotten. ALSA has been there 
for at least *five years* without documentation for most parts.

> > hacking (i.e. more features faster). Latency is an issue? - Well you
> > can't play sound without userspace creating it so you're not adding any
> > new problems.
>
> Capture.
>
If you are not doing DMA from the sound card to kernel memory and then 
directly to disk blocks, you are using user space apps period. So what's 
different with capture?

> Rene.
