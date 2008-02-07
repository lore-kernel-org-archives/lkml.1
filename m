Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYBGMa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYBGMa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbYBGMaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:30:17 -0500
Received: from www.tglx.de ([62.245.132.106]:32790 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbYBGMaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:30:15 -0500
Date: Thu, 7 Feb 2008 13:29:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
cc: Chris Holvenstot <cholvenstot@comcast.net>,
       Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-git15 Keyboard Issue?
In-Reply-To: <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>
Message-ID: <alpine.LFD.1.00.0802071324410.9204@apollo.tec.linutronix.de>
References: <1202302978.9058.13.camel@popeye>  <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>  <1202305740.9058.22.camel@popeye>  <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>  <1202318666.6406.13.camel@popeye>  <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
 <1202381094.6179.0.camel@popeye> <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Jiri Kosina wrote:

> On Thu, 7 Feb 2008, Chris Holvenstot wrote:
> 
> > I have been up and running now for about a half hour - since I did not 
> > hear your preference I stayed with git15 instead of jumping up to git16 
> > in an attempt to avoid introducing any unwanted changes.
> > 
> > The only non-standard thing I did was to use the nohpet directive at
> > boot time - I did NOT enter the previously used taskset command to alter
> > X's affinity. 
> > 
> > I have been banging away on my keyboard for about a half hour now with
> > no problems. While this is not conclusive on a 'soft' problem, from what
> > I experienced yesterday I would have expected to have seen the problem
> > by now.
> > 
> > Please let me know if there are any other items you would like to do or
> > options you would like me to try.
> 
> Thanks. So this clearly indicates that you are hitting either hardware 
> bug, or some bug in our HPET handling code.
> 
> Adding Ingo and Thomas to CC. Short summary -- Chris (and apparently other 
> people) are sometimes seeing repeated keypressess when HPET timer is used. 
> This doesn't happen when alternative clocksource is used.
> 
> Full thread: http://lkml.org/lkml/2008/2/6/100

Now, it would be interesting to know what the detailed difference is,
when the system is booted with and without nohpet.

Chris, can you please provide the dmesg output and the output of
/proc/timer_list for each bootup ?

.config file would be interesting as well.

Thanks,
	tglx
