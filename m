Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771Ab0AQMf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0AQMf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 07:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751Ab0AQMfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 07:35:25 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48816 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab0AQMfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 07:35:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bCObF2uyvGaPT6/xglY/0GxVJGdGqf02PhUlITyJtk8a0lR03dbqSkXGFbzUHHQE2Q
         J7WGP1WIm+aovnKtrIOwKUqdIyHLnsBNMeSdoQSXTEr4iVEqVzcTDJew8k5fsxk6gcPz
         stgfjYOoKdm45mTBV2Ms9qsuTJwfrrJdr0pFI=
Date: Sun, 17 Jan 2010 14:32:19 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.ker>
Subject: Re: 2.6.33-rc2: Reported regressions from 2.6.32
Message-ID: <20100117123218.GA3182@redhat.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <20100116174821.GA18306@redhat.com> <201001162257.16277.rjw@sisk.pl> <alpine.LFD.2.00.1001161402400.13231@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001161402400.13231@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 02:04:07PM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 16 Jan 2010, Rafael J. Wysocki wrote:
> >
> > > Immediately upon startup, screen is flickering (becomes
> > > lighter and darker again). The problem occurs with kernels
> > > 2.6.33-rc1 to 2.6.33-rc4, but not with kernel 2.6.32 and below.
> > 
> > We've already had several reports like this already.
> > 
> > Care to review the bugs linked to http://bugzilla.kernel.org/show_bug.cgi?id=14885
> > and check if none of them matches the problem you describe?
> 
> I suspect that should be fixed by commit 33814341f22 ("drm/i915: disable 
> LVDS downclock by default") that got merged today.
> 
> So try current -git. 
> 
> 		Linus


Tested with 6ccf80eb15ccaca4d3f1ab5162b9ded5eecd9971, still get
the flickering effect. so 33814341f22 does not seem to help.

-- 
MST
