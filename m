Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXJCDyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXJCDyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 23:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXJCDyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 23:54:03 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:41041 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151AbXJCDyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 23:54:01 -0400
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>,
       Mike Travis <travis@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Jason Wessel <jason.wessel@windriver.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benedikt Spranger <b.spranger@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LRH.0.999.0710021019310.23586@www.tglx.de>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org >
	 <alpine.LRH.0.999.0710021019310.23586@www.tglx.de>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 23:53:58 -0400
Message-Id: <1191383638.8719.9.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-02 at 11:17 +0200, Thomas Gleixner wrote:

[...]

> I have uploaded an update of the arch/x86 tree based on -rc9 to
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git x86
> 

[...]

> If there is anything we can help with the transition, please do not
> hesitate to ask.
> 
> Thanks,
> 
> 	Thomas, Ingo

Hi Thomas,

This latest x86 branch build and boot without problem with my usual
x86_64 config.

If you remember our conversation one month ago, I was unable to build
your tree.

I've upgraded my Ubuntu distribution from 7.04 to 7.10 beta this week,
maybe this fixed it.

But I still had to do some manual fixes to get the packaging steps
working:

mkdir arch/x86_64/boot/
ln -s ../../../arch/x86/boot/bzImage arch/x86_64/boot/bzImage


Best regards,

- Eric


