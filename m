Return-Path: <linux-kernel-owner+w=401wt.eu-S1762658AbXEPFF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762658AbXEPFF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXEPFFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:05:49 -0400
Received: from tuxrocks.com ([63.99.9.217]:44516 "EHLO tuxrocks.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbXEPFFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:05:49 -0400
Message-ID: <464A9077.1010403@tuxrocks.com>
Date: Wed, 16 May 2007 00:02:47 -0500
From: Frank Sorenson <frank@tuxrocks.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Frank Sorenson <frank@tuxrocks.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v4
References: <1178485128.31213.98.camel@localhost.localdomain>	 <200705142215.08910.s0348365@sms.ed.ac.uk> <1179180314.7074.36.camel@chaos>	 <200705142342.29994.s0348365@sms.ed.ac.uk> <1179217082.7074.47.camel@chaos>	  <4649BE4A.8000707@tuxrocks.com> <1179266013.12838.31.camel@chaos> <464A403A.3050202@tuxrocks.com>
In-Reply-To: <464A403A.3050202@tuxrocks.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Frank Sorenson wrote:
> Thomas Gleixner wrote:
>> Frank,
> 
>> On Tue, 2007-05-15 at 09:06 -0500, Frank Sorenson wrote:
>>> Hangs at boot here:
>>> 	Kernel alive
>>> 	Kernel direct mapping tables up to 100000000 @ 8000-d000
>>> (and that's it)
>>>
>>> This is a Dell Inspiron E1705 with a Core 2 Duo 2.16GHz
>>>
>>> highres-v3 also hung at the same point, but 2.6.21-git2-v2 worked
>>> 2.6.22-rc1 boots without problem
>> Can you please try the following three command line option addons ?
> 
>> 1: highres=off nohz=off
>> 2: highres=off
>> 3: nohz=off
> 
>> Thanks,
> 
>> 	tglx
> 
> All 3 hang at the same point.

I have tracked down the offending patch in the series to
x86-64-convert-to-clockevents.patch

Frank
- --
Frank Sorenson - KD7TZK
Linux Systems Engineer, DSS Engineering, UBS AG
frank@tuxrocks.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGSpB2aI0dwg4A47wRAglRAJ4mJgbJClPd0hkXKp+YHq7G5VxQvgCgkVkv
TtOjrSrjrwiHQPkNCqlq314=
=lu8g
-----END PGP SIGNATURE-----
