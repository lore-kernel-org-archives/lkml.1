Return-Path: <linux-kernel-owner+w=401wt.eu-S1764528AbZFOSu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764528AbZFOSu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZFOSuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:50:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53078 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbZFOSuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:50:12 -0400
Date: Mon, 15 Jun 2009 20:50:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [ARM] msm: make debugging UART (for DEBUG_LL)
	configurable
Message-ID: <20090615185008.GC10490@elf.ucw.cz>
References: <1245033557-10968-1-git-send-email-swetland@google.com> <1245033557-10968-2-git-send-email-swetland@google.com> <1245033557-10968-3-git-send-email-swetland@google.com> <20090615132018.GA14555@elf.ucw.cz> <a55d774e0906151130x3892346fx5aa1f62c387b2090@mail.gmail.com> <20090615183433.GB10490@elf.ucw.cz> <a55d774e0906151143r4181654cje37a9bbcfe092cec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0906151143r4181654cje37a9bbcfe092cec@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-15 11:43:23, Brian Swetland wrote:
> On Mon, Jun 15, 2009 at 11:34 AM, Pavel Machek<pavel@ucw.cz> wrote:
> >> > ...and those that do, have it at fixed uart, no?
> >>
> >> Well, I'd like to support the SoC generally, not just Dream -- it's
> >> used in a bunch of different devices, and there's nothing that forces
> >> you to use UART3 everywhere (I certainly have seen some 7k hardware
> >> that uses UART1 as the debug serial port).
> >
> > Aha, ok, I guess that should go to the changelog. (Nice bonus would be
> > if it was automatically/correctly set up when user selects machine
> > type... Actually, how does that work if you support few boards with
> > same kernel...?)
> 
> At this point a kernel for multiple boards with different DEBUG_LL
> uarts doesn't work correctly -- I'm not sure this could be done
> without making the debug macro code, etc, a lot messier (since it has
> to write to the physical uart address in early boot and I believe that
> happens before the machine type is determined, though maybe I'm
> wrong).

Ok, makes sense.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
