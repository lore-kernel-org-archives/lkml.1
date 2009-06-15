Return-Path: <linux-kernel-owner+w=401wt.eu-S1765658AbZFOSes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765658AbZFOSes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764471AbZFOSej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:34:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39554 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbZFOSei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:34:38 -0400
Date: Mon, 15 Jun 2009 20:34:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [ARM] msm: make debugging UART (for DEBUG_LL)
	configurable
Message-ID: <20090615183433.GB10490@elf.ucw.cz>
References: <1245033557-10968-1-git-send-email-swetland@google.com> <1245033557-10968-2-git-send-email-swetland@google.com> <1245033557-10968-3-git-send-email-swetland@google.com> <20090615132018.GA14555@elf.ucw.cz> <a55d774e0906151130x3892346fx5aa1f62c387b2090@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0906151130x3892346fx5aa1f62c387b2090@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-15 11:30:11, Brian Swetland wrote:
> On Mon, Jun 15, 2009 at 6:20 AM, Pavel Machek<pavel@ucw.cz> wrote:
> > Hi!
> >
> >> Signed-off-by: Brian Swetland <swetland@google.com>
> >> ---
> >>  arch/arm/mach-msm/Kconfig                    |   24 ++++++++++++++++++++++++
> >>  arch/arm/mach-msm/include/mach/debug-macro.S |   25 ++++++++++++++++++-------
> >>  arch/arm/mach-msm/include/mach/msm_iomap.h   |   12 ++++++++++++
> >>  arch/arm/mach-msm/include/mach/uncompress.h  |    7 +++++++
> >>  arch/arm/mach-msm/io.c                       |    3 +++
> >>  5 files changed, 64 insertions(+), 7 deletions(-)
> >
> > I'm not sure if this is appropriate for mainline at this point. It
> > seems like few people have debug cable at this point...
> >
> >> +config MSM_DEBUG_UART
> >> +     int
> >> +     default 1 if MSM_DEBUG_UART1
> >> +     default 2 if MSM_DEBUG_UART2
> >> +     default 3 if MSM_DEBUG_UART3
> >
> > ...and those that do, have it at fixed uart, no?
> 
> Well, I'd like to support the SoC generally, not just Dream -- it's
> used in a bunch of different devices, and there's nothing that forces
> you to use UART3 everywhere (I certainly have seen some 7k hardware
> that uses UART1 as the debug serial port).

Aha, ok, I guess that should go to the changelog. (Nice bonus would be
if it was automatically/correctly set up when user selects machine
type... Actually, how does that work if you support few boards with
same kernel...?)



									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
