Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYISXSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYISXSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYISXRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:17:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36515 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752138AbYISXRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:17:52 -0400
Date: Fri, 19 Sep 2008 18:17:49 -0500
From: Dean Nelson <dcn@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [PATCH 1/3] switch vector_irq[] from irq number to irq_desc pointer v2
Message-ID: <20080919231749.GA10245@sgi.com>
References: <20080919200212.GA6528@sgi.com> <20080919200449.GB6528@sgi.com> <48D40A97.2000402@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D40A97.2000402@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 01:24:55PM -0700, Mike Travis wrote:
> 
> Note that my recent patch from a couple of weeks ago, stripped almost all of
> the cpumask_t's from the io_apic functions.  Any chance we can apply them
> before we add more?
> 
> I'd be willing to merge in Dean's patch over the top of mine (or vice-versa).

Sorry Mike, I didn't realize you had any patches against io_apic functions.
You might take a look at the second patch in this patchset, I tried to
eliminate some of the cpumask_t's from being defined on the stack and to
pass only pointers to them as args. I didn't do all that could be done,
but just the ones near the main functions I was touching. You may have a
better way of doing it then I did.

Feel free to do whatever with this patchset. (I'm not going to be
reachable until Monday.)

FYI, this patchset was built against linux-next.

Thanks,
Dean
