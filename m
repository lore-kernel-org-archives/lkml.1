Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbXH1HOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbXH1HOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 03:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbXH1HOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 03:14:31 -0400
Received: from relay1.autostadt.de ([194.114.76.3]:22529 "EHLO
	relay1.autostadt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXH1HOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 03:14:30 -0400
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2007 03:14:30 EDT
X-IronPort-AV: E=Sophos;i="4.19,315,1183327200"; 
   d="scan'208";a="423657"
Subject: Re: PROBLEM: Suspend corrupts bios clock since 2.6.21
From: Andreas Steffan <a.steffan@deas-online.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-pm@lists.linux-foundation.org,
       pavel@suse.cz, linux-kernel@vger.kernel.org
In-Reply-To: <200708270045.09050.rjw@sisk.pl>
References: <fa.Hms7k1HwOwCbv7cPqUWGLhT5uyk@ifi.uio.no>
	 <46D1D6D1.5040203@shaw.ca>  <200708270045.09050.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 09:04:30 +0200
Message-Id: <1188284670.3742.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 00:45 +0200, Rafael J. Wysocki wrote:

> > > PS: I have not yet tried 2.6.22.4-65.fc7, but the latest 2.6.22 kernel
> > > before showed the same behaviour for me.
> > 
> > Please check if PM_TRACE is enabled in your kernel configuration. It 
> > will do this intentionally.
> 
> Yes, but only if you have "1" in /sys/power/pm_trace ...

I guess this is the case on my system.

I was/am encountering "resume from memory" problems. In approx 1 of 3
cases, the display remained switched off after resume, the harddisk was
spinning and it seemed the keyboard did not work either. This is the
reason why I've set 1 in /sys/power/pm_trace. I was hoping this could
help gathering information (dmsg after resume) to track down the
occasional "resume from memory" problem. I was not aware that the 1
in /sys/power/pm_trace could have side effects ("currupted" bios clock),
so I kept this setting.

Any help or suggestion how to track down the "suspend from memory
sometimes results in black display and keyboard not working problem"
would really be appreciated.

Now, I am trying kernel 2.6.22.4-65.fc7 (w/o pm_trace set to 1).
Unfortunately, with this kernel, pm-suspend and pm-hibernate both
don't work. Suspending freezes after

Suspending console(s)

with the lock lights flashing.

I was not observing this problem with 2.6.22.1-41. I'll try this
one again w/o /sys/power/pm_trace set to 1.

Thanks so far !
--
regards 
Andreas

+-----------------------------------------------------------+
Andreas Steffan              email: a.steffan@deas-online.de
Hamburg, Germany             mobil: +49179 3903615
+-----------------------------------------------------------+

In theory, practice and theory are the same, but in practice
they are different -- Larry McVoy
