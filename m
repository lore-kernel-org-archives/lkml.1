Return-Path: <linux-kernel-owner+w=401wt.eu-S1763339AbYCCVWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763339AbYCCVWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763192AbYCCVV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:21:56 -0500
Received: from xspect.dk ([212.97.129.87]:43639 "EHLO xspect.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763029AbYCCVVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:21:55 -0500
Date: Mon, 3 Mar 2008 22:21:53 +0100
From: "Klaus S. Madsen" <ksm@hjernemadsen.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080303212153.GV17932@hjernemadsen.org>
References: <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu> <20080303205227.GU17932@hjernemadsen.org> <20080303210526.GI13869@elf.ucw.cz> <20080303210647.GA20559@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303210647.GA20559@elf.ucw.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 22:06:47 +0100, Pavel Machek wrote:
> > > But I'm a bit puzzled by the fact that I'm aparently the only one how
> > > have encountered the problem? Maybe it's only a problem if one also uses
> > > PAE? (Thats just a wild guess to explain why I'm the only one seeing
> > > this).
> > 
> > I do not have NX capable CPU in machine using for suspend
> > testing. ... and you are using 32-bit userspace on 64-bit kernel,
> > right?
> 
> Sorry, I meant "32-bit userspace on 32-bit kernel"... but that on
> 64-bit capable cpu.
Yes. With 4 GB of RAM, so I use PAE, which is also required for NX. Just
to be sure, I disabled PAE, and sure enough, the problem disappeared.
 
I'll double that the commit I fingered actually caused the problem, but
I will not have time for this before tomorrw evening. 

Just to be sure: If I want to checkout the revision, just before the bad
commit I can do something like:

git checkout commit-id~1

Right? 

Thanks for spending time on this.

-- 
Kind regards
	Klaus S. Madsen
