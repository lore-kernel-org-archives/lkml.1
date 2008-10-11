Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbYJKJ5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbYJKJ5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 05:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYJKJ5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 05:57:35 -0400
Received: from solo.fdn.fr ([80.67.169.19]:53864 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbYJKJ5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 05:57:34 -0400
X-Greylist: delayed 1593 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Oct 2008 05:57:34 EDT
Date: Sat, 11 Oct 2008 11:30:53 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: David Schwartz <davids@webmaster.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: recv() hangs until SIGCHLD ?
Message-ID: <20081011093053.GB5541@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org
References: <23165e010810100943ua84228cn2faa03a5eb59255@mail.gmail.com> <MDEHLPKNGKAHNMBLJOLKOEDNAFAD.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEDNAFAD.davids@webmaster.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz, le Fri 10 Oct 2008 21:48:45 -0700, a écrit :
> > We are using the Boehm GC which uses the signals SIGXCPU and SIGPWR to
> > pause+restart the threads when running a GC cycle.
> > [...]
> >
> > However, when attaching GDB to our locked thread it seems that even
> > when the GC runs, recv() does not exit (the breakpoint after it is not
> > reached).
> 
> But you've yet to explain why it should return. Was it interrupted by
> a signal?

See quote above.

> Was data received?

No

> Is the socket non-blocking?

No

> Why isn't this expected behavior?  Blocking sockets block, full stop.

But using a signal is a common technique to have it getting unblocked,
since SUS says

« [EINTR] The recv() function was interrupted by a signal that was
caught, before any data was available. »

Samuel
