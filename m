Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbXEZQ0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbXEZQ0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760328AbXEZQ0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:26:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:58029 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753783AbXEZQ0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:26:15 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX19NOTB2iPNNfReMeTze/OK0kf5mJyV9Fab91Lwu2E
	vzEqk12X/chiyC
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 18:20:52 +0200
User-Agent: KMail/1.9.5
References: <20070524195616.234280@gmx.net> <200705261750.48816.mb@bu3sch.de> <20070526091309.0af20971.akpm@linux-foundation.org>
In-Reply-To: <20070526091309.0af20971.akpm@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>, Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261820.52240.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 26. Mai 2007 18:13 schrieben Sie:
> On Sat, 26 May 2007 17:50:48 +0200 Michael Buesch <mb@bu3sch.de> wrote:
> > Andrew,
> >
> > I am going to ignore Uwe from now on. It's simply impossible
> > to debug the problem the way he is responding.
> > Well, I'm not the first person in the Linux community adding
> > him to the killfile, ... .
>
> Well yes, there are some personality issues here ;) But the main thing is
> to struggle on and fix this bug, wherever it lies.
>
> > I ask to try wireless-dev, as the driver works perfectly fine
> > for me there, but he refuses to try it, too. So I'm stuck.
>
> I don't think he knows how to obtain it.
>
> Uwe, http://userweb.kernel.org/~akpm/git-wireless.patch.gz is the current
> wireless tree.  That's a patch against 2.6.22-rc3.  Could you please test
> that?  If that works then we know that the bug probably lies outside the
> b44 driver (or it was subsequently fixed).

Thank you, Andrew, just wait for a while. I am gonna try.....

>
> > I already tried your -mm kernel, but it crashes on my machine
> > for other reasons. (Yeah, I should look into them, too :P )
>
> err, please do.  Just the oops trace would be a start.
>
> > Andrew, is it possible that the breakage was introduced in the
> > merge process somehow? Didn't the patch apply cleanly? Are there
> > other changes to b44 I should know about in your tree?
>
> Only git-wireless.net modifies b44.c but if we're having IRQ assignment
> problems then we'd need to look elsewhere.  I guess you could diff
> rc2-mm1's b44.c against the expected version.
>
> > If it is really impossible to debug this problem, I'd like to
> > suggest you to drop the b44-ssb port completely.
>
> Well we don't know if that'll fix it.
>
> I believe that Uwe said that reverting the b44.c changes from rc2-mm1 fixes
> things for him?  Odd, but it still doesn't rule out acip/pci/platform
> changes as being the cause.

No, Andrew, not odd, but simply real! And Maximilian Engelhardt replied 
something similar on that.... : )

Cheers

Uwe

