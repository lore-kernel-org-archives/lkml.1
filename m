Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbXLISGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbXLISGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 13:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXLISFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 13:05:38 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1697 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751042AbXLISFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:05:35 -0500
Date: Sun, 9 Dec 2007 18:01:49 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [git pull] x86/hrtimer/acpi fixes
Message-ID: <20071209180149.GJ4381@ucw.cz>
References: <20071207183633.GC26778@elte.hu> <1197053386.32023.13.camel@cmn3.stanford.edu> <20071207185920.GA3006@elte.hu> <1197055769.32023.22.camel@cmn3.stanford.edu> <1197056910.32023.25.camel@cmn3.stanford.edu> <20071207195958.GA12529@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207195958.GA12529@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

> @@ -78,15 +79,35 @@ EXPORT_SYMBOL_GPL(check_tsc_unstable);
>   *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
>   *  (mathieu.desnoyers@polymtl.ca)
>   *
> + *  ns += offset to avoid sched_clock jumps with cpufreq
> + *
>   *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
>   */

Did john add the 'ns+=' or do comments need reorder?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
