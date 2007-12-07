Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbXLGT3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbXLGT3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbXLGT3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:29:35 -0500
Received: from smtp3.Stanford.EDU ([171.67.20.26]:60814 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbXLGT3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:29:34 -0500
Subject: Re: [git pull] x86/hrtimer/acpi fixes
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: nando@ccrma.Stanford.EDU, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20071207185920.GA3006@elte.hu>
References: <20071207183633.GC26778@elte.hu>
	 <1197053386.32023.13.camel@cmn3.stanford.edu>
	 <20071207185920.GA3006@elte.hu>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 11:29:29 -0800
Message-Id: <1197055769.32023.22.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-07 at 19:59 +0100, Ingo Molnar wrote:
> * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> 
> > Ingo, I was about to post about timer problems in 2.6.23.9+rt12 when I 
> > saw this. Would this be related / should I test / will this solve 
> > everything? :-)
> > 
> > What I'm seeing is jack "delays" that go away if I boot with 
> > "idle=poll", just like it was happening a long time ago. Smells like 
> > 'time of day' glitches when the process switches cpus (this is on a 
> > dual core intel laptop).
> 
> does it go away with hpet=disable as well? If yes then there could be a 
> relation. If not then it's something else and we need to debug it.

Nope, it doesn't still getting "delay" and "xrun" messages galore. 
-- Fernando


