Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbYBGKv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbYBGKv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbYBGKvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:51:49 -0500
Received: from styx.suse.cz ([82.119.242.94]:46992 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754485AbYBGKvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:51:49 -0500
Date: Thu, 7 Feb 2008 11:51:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Holvenstot <cholvenstot@comcast.net>
cc: Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-git15 Keyboard Issue?
In-Reply-To: <1202381094.6179.0.camel@popeye>
Message-ID: <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>
References: <1202302978.9058.13.camel@popeye>  <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>
  <1202305740.9058.22.camel@popeye>  <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
  <1202318666.6406.13.camel@popeye>  <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
 <1202381094.6179.0.camel@popeye>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Chris Holvenstot wrote:

> I have been up and running now for about a half hour - since I did not 
> hear your preference I stayed with git15 instead of jumping up to git16 
> in an attempt to avoid introducing any unwanted changes.
> 
> The only non-standard thing I did was to use the nohpet directive at
> boot time - I did NOT enter the previously used taskset command to alter
> X's affinity. 
> 
> I have been banging away on my keyboard for about a half hour now with
> no problems. While this is not conclusive on a 'soft' problem, from what
> I experienced yesterday I would have expected to have seen the problem
> by now.
> 
> Please let me know if there are any other items you would like to do or
> options you would like me to try.

Thanks. So this clearly indicates that you are hitting either hardware 
bug, or some bug in our HPET handling code.

Adding Ingo and Thomas to CC. Short summary -- Chris (and apparently other 
people) are sometimes seeing repeated keypressess when HPET timer is used. 
This doesn't happen when alternative clocksource is used.

Full thread: http://lkml.org/lkml/2008/2/6/100

-- 
Jiri Kosina
SUSE Labs
