Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbXEOOzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbXEOOzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 10:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbXEOOzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 10:55:43 -0400
Received: from tuxrocks.com ([63.99.9.217]:50620 "EHLO tuxrocks.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbXEOOzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 10:55:43 -0400
X-Greylist: delayed 2830 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 10:55:43 EDT
Message-ID: <4649BE4A.8000707@tuxrocks.com>
Date: Tue, 15 May 2007 09:06:02 -0500
From: Frank Sorenson <frank@tuxrocks.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v4
References: <1178485128.31213.98.camel@localhost.localdomain>	 <200705142215.08910.s0348365@sms.ed.ac.uk> <1179180314.7074.36.camel@chaos>	 <200705142342.29994.s0348365@sms.ed.ac.uk> <1179217082.7074.47.camel@chaos>
In-Reply-To: <1179217082.7074.47.camel@chaos>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Thomas Gleixner wrote:
> I've uploaded a new version of the x86_64 highres/dyntick patches:
> 
> http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v4.patch

Hangs at boot here:
	Kernel alive
	Kernel direct mapping tables up to 100000000 @ 8000-d000
(and that's it)

This is a Dell Inspiron E1705 with a Core 2 Duo 2.16GHz

highres-v3 also hung at the same point, but 2.6.21-git2-v2 worked
2.6.22-rc1 boots without problem

Is there any information I can provide to help track down the problem?

Thanks,

Frank
- --
Frank Sorenson - KD7TZK
Linux Systems Engineer, DSS Engineering, UBS AG
frank@tuxrocks.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGSb5JaI0dwg4A47wRAjkgAJ9Urvpo+cTAbRvblYovBYy3PD76jACfbtjj
EZSrOZDFMnOYjc02nHSAxaM=
=/ffY
-----END PGP SIGNATURE-----
