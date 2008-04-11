Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYDKWJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYDKWJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 18:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbYDKWJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 18:09:37 -0400
Received: from web52502.mail.re2.yahoo.com ([206.190.48.185]:20913 "HELO
	web52502.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756025AbYDKWJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 18:09:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=UJCA5mBTFFK9066/o1WZaHFP+oqUCWeSzOwMgE1BhCGyAZ4g8CGfHGR7BGObpIwjfrZPG6/mx90JBa2JV+g2TBDL9+E66uXYXYWgVYmPjRoiM5kgsIcE68N0TQPBjUL/Ixr5Z7H9o6CZkxroL5rrbHSon58uOxbgJy6G0pOYSsE=;
X-YMail-OSG: zh2AnvsVM1l9wOo77K0aAToUVn87lUz0tC32hK1ttgeIwoa7.SqZvwPr34h6tQezvhw7nXdNOKvhcjkuiLxh7rEfw3AdfbUuYEsCf0LMvoZl2NE.YicLigkElJo7gwL4_vHaCaow6_3ySFXD7IHDPjkp
Date: Fri, 11 Apr 2008 15:09:35 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: AMD Quad Core clock problem?
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47FFD3F3.50107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <735874.9676.qm@web52502.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Chris Snook <csnook@redhat.com> wrote:

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

Is it possible due to calibration that ntpd isn't able
to correct the problem? Is there a setting to make ntp
more agressive?


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
