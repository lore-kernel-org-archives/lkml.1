Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbXD1QYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbXD1QYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXD1QYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:24:22 -0400
Received: from waste.org ([66.93.16.53]:53402 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbXD1QYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:24:21 -0400
Date: Sat, 28 Apr 2007 11:11:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-ID: <20070428161136.GL11166@waste.org>
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org> <20070425112133.4ae86399.randy.dunlap@oracle.com> <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org> <20070428030805.GA13331@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428030805.GA13331@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 11:08:05PM -0400, Dave Jones wrote:
> On Wed, Apr 25, 2007 at 08:02:07PM -0700, Andrew Morton wrote:
> 
>  > > Yep, I was going to mention your scripts but you beat me to it.
>  > > 
>  > > I'll be glad to help maintain such animals if wanted.
>  > > 
>  > wanted ;)
>  > 
>  > At least, it would be interesting to investigate the usefulness.  I suspect
>  > it will prove to be very useful for the little things.
> 
> Randy and I got together and hashed out a first cut at this.
> (Randy actually gutted quite a lot of what I originally wrote, so deserves
>  much kudos for improving this beyond my initial crappy version).
> You can find the script at http://www.codemonkey.org.uk/projects/checkpatch/
> There's also a git clonable tree there (only http right now).
> 
> http://www.codemonkey.org.uk/projects/checkpatch/example.log shows
> what fell out of running it on my mbox of lkml from the past month.
> Some of them are kinda noisy, and perhaps should be moved under --pedantic
> 
> I'm all ears for additional regexps, bug reports or other suggestions.

Neat.

Does it check for:

functions marked extern?
pulling in external functions or variables without a header file?
return used as a function, eg return(foo);?

-- 
Mathematics is the supreme nostalgia of our time.
