Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbYDKVgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbYDKVgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYDKVgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:36:33 -0400
Received: from web52504.mail.re2.yahoo.com ([206.190.48.187]:20677 "HELO
	web52504.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755482AbYDKVgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:36:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=TzxbR5ce3tbt4iPT3H3iD7XmNE+nsG9u/hopXX7Glb+cfjRgBCBAzjvZ3Lif3orIoDnSGdTSI7khPeNnRjd2kSpuX16ntwulooUhfxXau8zkGnyzcTgIvhyAEUEMKITJ28zHjK6XLNvEkydZcFMNVlgYBVW2O+GVXX7Iq6m65Y0=;
X-YMail-OSG: _W.gUdQVM1ntMhLQktD0OZUWofUHaKbScJy3PrlNyn74l_q1sJSSCxCKnt2WiWwgk8POMJ9cRmGZ0VH83rftDlOI8GLgFkcE1BpflkjeRYH.dTz869TyPeP33c8JGM1RfNPUpn2I05W.I1MgBt7qrSYaC7JxbRRtCIFJIGgVdFY-
Date: Fri, 11 Apr 2008 14:36:31 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: AMD Quad Core clock problem?
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47FFD3F3.50107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <821384.64293.qm@web52504.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Chris Snook <csnook@redhat.com> wrote:

> Marc Perkel wrote:

> > 
> > 
> > The drift is small. It loses a few seconds every
> hour.
> > And it might not be kernel related. I just
> remembered
> > the early dual core days when this took months to
> get
> > right. I'm running several dual core computers and
> the
> > only one drifting is the quad. All are running the
> > same OS and kernel.
> 
> With the older chips, each core had its own TSC,
> which caused 
> synchronization problems.  The Barcelona generation
> chips (including 
> your Phenom) have a constant frequency TSC on the
> northbridge, so they 
> should be immune to these problems.
> 
> If it's steadily losing a few seconds every hour,
> it's probably just 
> slightly mis-calibrated hardware.  ntp should fix
> this right up.  If the 
> drift is more extreme than ntp can correct for, or
> the drift keeps 
> changing, or time is jumping around, that is
> definitely something that 
> could be a bug.
> 
> > hpet clockevent registered
> > TSC calibrated against HPET
> > Marking TSC unstable due to TSCs unsynchronized
> 
> It's possible that in future kernels we'll be a few
> clock cycles more 
> accurate in calibrating this on Barcelona chips, but
> calibration is only 
> as good as the standard of comparison.  There will
> always be hardware 
> that's slightly off, so run ntp, or use a nightly
> ntpdate cronjob.  If 
> your time starts drifting drastically or jumping
> around, please yell 
> really loud.
> 
> -- Chris
> 

No - it's not wild like it was back in the early X2
days and I think you're right about the drift being
normal. Interesting thing though I am running ntpd and
it's not working. I am fairly sure the ntp.conf file
is exactly as it was installed by fedora. I'm now
looking into that.

Thanks for your help. Sorry for the false alarm. But
if thee was an issue I thought you would want to know
it.



Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
