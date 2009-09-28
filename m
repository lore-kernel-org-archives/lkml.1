Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZI1VRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZI1VRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZI1VRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:17:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35594 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZI1VRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:17:48 -0400
Date: Mon, 28 Sep 2009 23:17:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Joseph Cihula <joseph.cihula@intel.com>,
       Shane Wang <shane.wang@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Message-ID: <20090928211745.GA2119@elf.ucw.cz>
References: <200909142051.n8EKpiOM017912@terminus.zytor.com> <200909262344.21257.rjw@sisk.pl> <20090928210252.GD1960@elf.ucw.cz> <200909282307.56190.rjw@sisk.pl> <4AC1267D.6020405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC1267D.6020405@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-09-28 14:11:25, H. Peter Anvin wrote:
> On 09/28/2009 02:07 PM, Rafael J. Wysocki wrote:
> >>
> >> Well, I worry that S3 support for TXT makes TXT completely useless. A
> >> little liquid nitrogen, remove RAM, place it in another machine,
> >> modify it in any way you want, more liquid nitrogen, place it back.
> >>
> >> Oops, protection provided by TXT is lost.
> > 
> > Ah, I see your point now.
> > 
> 
> Shane Wang sent me a patch for S3 support, but it missed the merge window:
> 
> 	http://marc.info/?i=4A9CE0B2.5060608@intel.com
> 
> *As far as I understand* -- and I haven't looked into it in detail yet,
> having just come back from Plumber's -- this provides integrity
> protection, not content extraction protection.

How does it provide integrity protection? I'm free to modify RAM
content in the other machine....
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
