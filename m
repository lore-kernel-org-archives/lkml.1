Return-Path: <linux-kernel-owner+w=401wt.eu-S1762912AbZFKLKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762912AbZFKLKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760199AbZFKLJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:09:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51661 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbZFKLJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:09:53 -0400
Date: Thu, 11 Jun 2009 13:09:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611110946.GA7523@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz> <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com> <20090611081012.GD8592@elf.ucw.cz> <a55d774e0906110127k1633dd90x96863c3dd6f888cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0906110127k1633dd90x96863c3dd6f888cf@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 01:27:43, Brian Swetland wrote:
> On Thu, Jun 11, 2009 at 1:10 AM, Pavel Machek<pavel@ucw.cz> wrote:
> > On Wed 2009-06-10 10:43:53, Brian Swetland wrote:
> >>
> >> Our current working tree (for the donut branch) is against 2.6.29:
> >> http://android.git.kernel.org/?p=kernel/msm.git;a=shortlog;h=refs/heads/android-msm-2.6.29
> >
> > Strange, I attempted downloading this overnight (285MB!)
> 
> Hm.  I think if you add this as a remote to an existing repository
> containing the kernel (these trees are based on v2.6.27 and v2.6.29
> respectively) it should only pull the deltas (which aren't that
> enormous).

I tried pulling deltas (by specifying --template=...), that was
285MB. Maybe I screwed something up.

Anyway, now I have a tree, and yes it compiles. (After some
"interesting" questions; perhaps defconfig should be updated?)

Unfortunately, upon fastboot boot uImage, it hangs with black screen
and backlight on. I _think_ I got config right, most "interesting"
question was 

AMSS modem firmware version
  1. 6.2.10 (MSM_AMSS_VERSION_6210)
  2. 6.2.20 (MSM_AMSS_VERSION_6220)
> 3. 6.2.20 + New ADSP (MSM_AMSS_VERSION_6225)
  4. 6.3.50 (MSM_AMSS_VERSION_6350) (NEW)

...and I just selected "3" being default. No help available :-(. I
have cupcake installed, and I believe I installed radio update
required for cupcake. Can someone help? (And write Kconfig help text?
:-).

> > Ok, could we get the boards renamed? g1 is known as dream, having
> > trout+dream+g1+adp1 names for same piece of hardware is unnice.
> 
> It's hard to have a single name since carriers tend to use different
> names in different markets.  We often start work on kernel support
> long before a product is announced, so we've been using the fish names
> to allow us to register board names with the ARM machine registry
> early on and not use bogus internal-only machine IDs.

I know naming stuff is hard. But dream/g1/adp1 are both recognized by
outside people. I don't think "trout" has similar level of
recognition.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
