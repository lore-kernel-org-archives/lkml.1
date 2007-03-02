Return-Path: <linux-kernel-owner+w=401wt.eu-S1423060AbXCBM1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423060AbXCBM1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 07:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423057AbXCBM07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 07:26:59 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35372 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423055AbXCBM07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 07:26:59 -0500
Date: Fri, 2 Mar 2007 13:26:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "Michael S. Tsirkin" <mst@mellanox.co.il>, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@stusta.de>,
       linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] 2.6.21-rc1: known regressions (v2) (part 1)
Message-ID: <20070302122641.GA3034@elf.ucw.cz>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070226220152.GA29575@stusta.de> <20070228211318.GB4301@mellanox.co.il> <b6a2187b0702281945n5f62a6b5w1c535de3ef9aaa8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0702281945n5f62a6b5w1c535de3ef9aaa8f@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-03-01 11:45:35, Jeff Chua wrote:
> On 3/1/07, Michael S. Tsirkin <mst@mellanox.co.il> wrote:
> 
> > with 2.6.20, pressing Fn/F4 generates an ACPI event and triggers suspend to RAM.
> >
> > On 2.6.21-rc2, after resume (when the box is accessible from network),
> > pressing Fn/F4 again does not seem to have any effect.
> 
> I have the same problem on my IBM X60s on rc1 and rc2. Can't resume
> from RAM, can't suspend to disk. It is possible to revert all the
> changes to ACPI and test it?

As I said elsewhere in the thread, suspend/resume to RAM works ok on
my thinkpad x60. I posted my .config there, perhaps difference is in
it? Ingo identified KVM as possible culprit.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
