Return-Path: <linux-kernel-owner+w=401wt.eu-S1764934AbXJRRYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764934AbXJRRYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbXJRRYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:24:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51064 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144AbXJRRYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:24:04 -0400
Date: Thu, 18 Oct 2007 19:25:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: - x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch removed from -mm tree
Message-ID: <20071018172536.GB21908@uranus.ravnborg.org>
References: <200710180709.l9I794J2031878@imap1.linux-foundation.org> <471784C2.3080807@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471784C2.3080807@sun.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 09:07:30AM -0700, Yinghai Lu wrote:
> 
> akpm@linux-foundation.org wrote:
> >The patch titled
> >     x86_64: check MSR to get MMCONFIG for AMD Family 10h Opteron
> >has been removed from the -mm tree.  Its filename was
> >     x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch
> >
> >This patch was dropped because it was merged into mainline or a subsystem 
> >tree
> >
> >------------------------------------------------------
> >Subject: x86_64: check MSR to get MMCONFIG for AMD Family 10h Opteron
> >From: Yinghai Lu <Yinghai.Lu@Sun.COM>
> >
> >So even MCFG is not there, we still can use MMCONFIG.
> >
> >Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> >Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >---
> >
> > arch/i386/pci/mmconfig-shared.c |   58 ++++++++++++++++++++++++++----
> > 1 file changed, 52 insertions(+), 6 deletions(-)
> 
> Andrew,
> 
> where was this one going? Thomas got it?

Yep - in his mm branch.
See:
http://git.kernel.org/?p=linux/kernel/git/tglx/linux-2.6-x86.git;a=commit;h=51fb449df2717b6e9eda88f4be4bce0a69bf04aa

	Sam
