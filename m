Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZI3GzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZI3GzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 02:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZI3GzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 02:55:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56399 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZI3GzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 02:55:12 -0400
Date: Wed, 30 Sep 2009 08:54:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Wang, Shane" <shane.wang@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Message-ID: <20090930065448.GB11652@elf.ucw.cz>
References: <200909142051.n8EKpiOM017912@terminus.zytor.com> <200909262344.21257.rjw@sisk.pl> <20090928210252.GD1960@elf.ucw.cz> <200909282307.56190.rjw@sisk.pl> <4AC1267D.6020405@zytor.com> <20090928211745.GA2119@elf.ucw.cz> <4AC1AA61.8070408@intel.com> <20090929171318.GC14405@elf.ucw.cz> <20090929191951.18315e94@infradead.org> <037F493892196B458CD3E193E8EBAD4F01ED9FE3B1@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <037F493892196B458CD3E193E8EBAD4F01ED9FE3B1@pdsmsx502.ccr.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-30 10:16:55, Wang, Shane wrote:
> Arjan van de Ven wrote:
> > On Tue, 29 Sep 2009 19:13:18 +0200
> > Pavel Machek <pavel@ucw.cz> wrote:
> > 
> >> Ok, and what prevents me from commenting out the MAC checking code?
> >> 
> > 
> > because the bios verified some code that verified the kernel which
> > includes the MAC checking code .. as part of returning from S3 ?
> 
> Yes, S3 sleep/resume cause another cycle to build the measured environment.
> i.e. SINIT will verify tboot, tboot will verify kernel mem, kernel will verify userspace mem.
> If you comment out the MAC checking code in any party, the chain will lost and S3 resume will fail.
> 

Ok, that means that you are protecting integrity but not secrecy?
Should that be written down in documentation, along with threat model?

So I modify the RAM content so that BIOS does not think measured
environment existed before suspend?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
