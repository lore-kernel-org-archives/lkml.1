Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbXIWTKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbXIWTKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 15:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbXIWTKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 15:10:47 -0400
Received: from www.osadl.org ([213.239.205.134]:55208 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755288AbXIWTKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 15:10:46 -0400
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325,
	related to clockevents
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200709231257.12213.rjw@sisk.pl>
References: <200709231257.12213.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 23 Sep 2007 21:10:41 +0200
Message-Id: <1190574641.4035.148.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-23 at 12:57 +0200, Rafael J. Wysocki wrote:
> Hi Thomas,
> 
> Unfortunately, my observation that the patch series:
> 
> http://tglx.de/projects/hrtimers/2.6.23-rc4/patch-2.6.23-rc4-hrt1.patches.tar.bz2
> 
> worked with 2.6.23-rc4 was wrong.  It _sometimes_ works, but usually doesn't
> boot, just like 2.6.23-rc4-mm1, 2.6.23-rc6-mm1 and everything in between with
> the above patch series applied.  I've also tried:
> 
> http://tglx.de/projects/hrtimers/2.6.23-rc5/patch-2.6.23-rc5-hrt1.patches.tar.bz2
> http://tglx.de/projects/hrtimers/2.6.23-rc6/patch-2.6.23-rc6-hrt2.patch
> 
> with the same result.
> 
> The problematic patch is x86_64-convert-to-clockevents.patch .
> 
> Since the boot fails very early, before any messages reach the (VGA) console,
> I have no idea what to do next, except for digging in the code.

Ok, lets track it down. Is there any difference when you add:

nohz=off
highres=off
noapictimer

or any combinations of the above to the kernel command line ?

	tglx


