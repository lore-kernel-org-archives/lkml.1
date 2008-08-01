Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYHACFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYHACFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 22:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYHACFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 22:05:22 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:55783 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYHACFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 22:05:22 -0400
Message-ID: <48926FC3.3000706@keyaccess.nl>
Date: Fri, 01 Aug 2008 04:06:59 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       =?ISO-8859-15?Q?P=E1draig_Brady?= <P@draigBrady.com>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
References: <20080729232951.GB11223@linux-os.sc.intel.com> <488FAB2B.7050405@zytor.com> <20080730100326.GA9683@elte.hu> <20080730182539.GA17140@elte.hu> <20080730234102.GF11223@linux-os.sc.intel.com> <20080731212915.GH2729@elte.hu> <20080731215808.GB8563@linux-os.sc.intel.com> <20080731221435.GS23938@one.firstfloor.org> <20080731221924.GD8563@linux-os.sc.intel.com> <alpine.LFD.1.10.0807311531271.3277@nehalem.linux-foundation.org> <20080731225004.GD22426@elte.hu>
In-Reply-To: <20080731225004.GD22426@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-08-08 00:50, Ingo Molnar wrote:

> there are a handful of old ISA-ish drivers that can crash randconfig 
> kernels in various ways. [indefinite lockups, crashes, stomped-over 
> hardware, non-working keyboard, etc.]
> 
> I mapped most of them out via many months of trial-and-error - but it 
> would still be nice to have some separate config option to disable the 
> known ones. CONFIG_ALLOW_NON_GENERIC or something like that - which i 
> would unset in the randconfig runs.
> 
> ( They are not CONFIG_BROKEN per se, because often it's hardware that
>   cannot be probed in any reliable way - the driver just assumes it's 
>   there. )

If you have a list, I might be able to do something about some of them.

Rene.
