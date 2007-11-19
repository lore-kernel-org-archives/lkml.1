Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbXKSQGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbXKSQGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 11:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbXKSQGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 11:06:07 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:32341 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706AbXKSQGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 11:06:05 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Mon, 19 Nov 2007 17:00:24 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
cc: "Andreas Herrmann" <aherrman@arcor.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fix UTS_MACHINE to be i386 for 32-bit build
 and x86_64 for 64-bit build
Message-ID: <20071119160024.GA11309@alberich.amd.com>
References: <20071117143731.GA7129@uranus.ravnborg.org>
 <20071119093437.GA5104@devil>
 <20071119104129.GA10731@uranus.ravnborg.org>
MIME-Version: 1.0
In-Reply-To: <20071119104129.GA10731@uranus.ravnborg.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Nov 2007 16:00:23.0113 (UTC)
 FILETIME=[4AC0C390:01C82AC5]
X-WSS-ID: 6B5F6C9307S3019444-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 11:41:29AM +0100, Sam Ravnborg wrote:
> On Mon, Nov 19, 2007 at 10:34:37AM +0100, Andreas Herrmann wrote:
> > On Sat, Nov 17, 2007 at 03:37:31PM +0100, Sam Ravnborg wrote:
> > > 
> > > Note: This patch does not fix the uname -m issue - to do so
> > > Andreas' patch is needed.
> > > 
> > > 	Sam
> > 
> > Linus,
> > 
> > The issue Sam refers to is that UTS_MACHINE is set to "x86" instead of
> > "i386" or "x86_64" when building with ARCH=x86. Thus the new kernel
> > when booted will give either "x86" on x86_64 and many i386 systems or
> > even "x66" on other i386 systems for 'uname -m'.
> > 
> > Many tools rely on the usual values of "x86_64", "i366" and "i686"
> > here. So we shouldn't change this.
> 
> Andreas - I will suggest you to submit a new patch with
> a better changelog where you jsut describe what you fix.
> The above explanations looks a bit weird if read stand alone.

Ok, I'll resend the patch with an updated changelog asap.

> You can always add additional comments after the line containing:
> ---
> 
> In this way it is not included in the changelog but Linus can read it.
> 
> Anyway - your patch has my ack.

Thanks,


Andreas



