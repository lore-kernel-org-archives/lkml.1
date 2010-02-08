Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab0BHRhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 12:37:13 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:33540 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751764Ab0BHRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:37:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YtuSsP1HDKtx/zqGRFA+3B0IzYgmncSA7n8CARgBjXs13fQYeQutJbeH3uC0ToE/aXuAL7uEgCNN8rsH5rLZpmtN8nqEGGIcaYFzWV3nwdVDBrYSqEEPslg3sBk0bNBD;
Date: Mon, 8 Feb 2010 09:35:51 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Wilson <chris@chris-wilson.co.uk>, tomas m <tmezzadra@gmail.com>
Subject: Re: [Bug #15004] i915: *ERROR* Execbuf while wedged
Message-ID: <20100208093551.58a10643@jbarnes-piketon>
In-Reply-To: <20100208172410.GA11311@think>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
	<de962C6zBxL.A.bvE.cFiZLB@chimera>
	<20100205110100.57852c31@jbarnes-piketon>
	<20100205190916.GD2858@think>
	<20100205111747.6619b09b@jbarnes-piketon>
	<20100208172410.GA11311@think>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010 12:24:10 -0500
Chris Mason <chris.mason@oracle.com> wrote:

> On Fri, Feb 05, 2010 at 11:17:47AM -0800, Jesse Barnes wrote:
> > On Fri, 5 Feb 2010 14:09:16 -0500
> > Chris Mason <chris.mason@oracle.com> wrote:
> > 
> > > On Fri, Feb 05, 2010 at 11:01:00AM -0800, Jesse Barnes wrote:
> > > > On Mon,  1 Feb 2010 01:43:19 +0100 (CET)
> > > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > 
> > > > > This message has been generated automatically as a part of a
> > > > > report of regressions introduced between 2.6.31 and 2.6.32.
> > > > > 
> > > > > The following bug entry is on the current list of known
> > > > > regressions introduced between 2.6.31 and 2.6.32.  Please
> > > > > verify if it still should be listed and let me know (either
> > > > > way).
> > > > > 
> > > > > 
> > > > > Bug-Entry	:
> > > > > http://bugzilla.kernel.org/show_bug.cgi?id=15004
> > > > > Subject		: i915: *ERROR* Execbuf while wedged
> > > > > Submitter	: tomas m <tmezzadra@gmail.com>
> > > > > Date		: 2010-01-07 18:53 (25 days old)
> > > > 
> > > > Can you bisect this to a particular kernel commit?  The
> > > > particular error message means the kernel detected a GPU hang.
> > > > That's usually a userspace bug, but the kernel should recover
> > > > from it.
> > > 
> > > I see these about once a week, which would be a very difficult
> > > bisect. The kernel does recover when I reboot, but beyond that
> > > the messages loop forever.
> > > 
> > > I haven't yet seen it on 2.6.33-rc, but I'm still struggling with
> > > suspend/resume failures and haven't really had a one week up time
> > > yet.
> 
> Ok, updating to rc7 and updating my xf86 driver to 2.10 seems to have
> fixed up my suspend/resume problems.  So, I should be able to trigger
> the execbuf problem again.

I've heard some reports that the 2D driver introduces and fixes hangs,
so it's possible 2.10 will fix both issues for you.

> Well, the rebooting isn't a huge deal, but if there's something I can
> track/kick or force to core dump, would it help?

We do have a test in intel-gpu-tools that will instigate a hang, but it
would be best to figure out what's causing it in your environment.

-- 
Jesse Barnes, Intel Open Source Technology Center
