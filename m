Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbXEQEbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbXEQEbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 00:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759010AbXEQEb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 00:31:29 -0400
Received: from tuxrocks.com ([63.99.9.217]:55788 "EHLO tuxrocks.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbXEQEb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 00:31:28 -0400
Message-ID: <464BD945.2070007@tuxrocks.com>
Date: Wed, 16 May 2007 23:25:41 -0500
From: Frank Sorenson <frank@tuxrocks.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Frank Sorenson <frank@tuxrocks.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v5
References: <1178485128.31213.98.camel@localhost.localdomain> <1179309789.3764.20.camel@chaos> <464B5FF7.5070701@tuxrocks.com>
In-Reply-To: <464B5FF7.5070701@tuxrocks.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Frank Sorenson wrote:

> After adding *lots* of early_printks, I see that it hangs in
> hpet_is_known(hdp) called from hpet_alloc(&hd), so something in the hpet
> code is still buggy.  Adding nohpet to the kernel command line allows it
> to boot correctly.

Hrm.  Looks like it gets past the hpet_is_known  There's still something
in the hpet detection code, but I didn't get to the bottom of it yet.
I'll do some more debugging to track down where it's really hanging.
Sorry for the noise.

Frank
- --
Frank Sorenson - KD7TZK
Linux Systems Engineer, DSS Engineering, UBS AG
frank@tuxrocks.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGS9lFaI0dwg4A47wRApdSAJoDsFphRHZq/tu3d4nJaqMvt+tLGQCghf1L
OCuPEpCRr9tBSnBdVNiShRE=
=NDZn
-----END PGP SIGNATURE-----
