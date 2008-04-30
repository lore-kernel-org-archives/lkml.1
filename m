Return-Path: <linux-kernel-owner+w=401wt.eu-S1764037AbYD3R7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764037AbYD3R7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757401AbYD3R6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:58:48 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:23982 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756464AbYD3R6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:58:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MkqhutlfA5McrFo4wp/n8RVmnc1M1hHPZCVoQ7ClivBD+hsRs4/rABPav0QUq3Jmo1BxPVGAIXjC68rwXAAvX+eESkA8voKSF2jKjgHUP+eFeMwAgkL8BrnB3M0tkj/iEzLzED8aVYRQPSvLnlDGlb+Umo+QnBWrdgtMO+MfITM=  ;
X-YMail-OSG: KRSqCCoVM1mREVq3RbpIGxUm0jCnMyWjq.9G8ZwD4u.keXxsYFjx5pGmlmoDGKm3FRgcXZE0YdRUSmTmjTE8uls8jr7mfE1Ju_gsFaSRR3nRQvuq4cO5qpJD6UhxKMRNzuw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Trent Piepho <tpiepho@freescale.com>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Wed, 30 Apr 2008 10:49:06 -0700
User-Agent: KMail/1.9.6
Cc: Ben Nizette <bn@niasdigital.com>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <200804291456.52889.david-b@pacbell.net> <Pine.LNX.4.64.0804291746410.20563@t2.domain.actdsltmp>
In-Reply-To: <Pine.LNX.4.64.0804291746410.20563@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804301049.07115.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008, Trent Piepho wrote:
> On Tue, 29 Apr 2008, David Brownell wrote:
> >
> >> If anything,
> >> the parsing code is simpler than what David has.
> >
> > Apples vs oranges.  Use the same command syntax if you're going
> > to make comparisons; I can save even more with "+export/-unexport"
> > syntax.  For comparable syntax, your stuff *IS* bigger.
> 
> If the code you wrote it not too complex, then why is the code I wrote, which
> is not larger, too complex?

Well, Andrew *did* object to the complexity.  But that wasn't
the point I was making there:  you were comparing apples and
oranges ... which makes it particularly easy to reach desired
conclusions like "only *this* one tastes like oranges!".


> >> David's code for parsing the control file plus code for generating a mapping
> >> range file would certainly be larger.
> >
> > The #3 option presumes some file listing chips and ranges too,
> > since GPIOs are exported only on demand.  Ditto #2 and #4...
> 
> You never answered how one was supposed to get the proper device from a
> script.

No I didn't.  But that's why I liked Ben's suggestion of creating
sysfs nodes for each gpio_chip.  That's actually a good example
of why folk like the one-value-per-attribute model with sysfs, at
least for information that would be used with scripting.

- Dave

