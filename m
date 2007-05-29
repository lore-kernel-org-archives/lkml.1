Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbXE2Mxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbXE2Mxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbXE2MxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:53:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:37005 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbXE2MxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=h3JodViXqpHWUxgCtfwiLUYMwUs0MVs8bLzW7gWJegtsu2RrW1zwUxmNMxZk7Tf8BQnWEfqf0+wxxw24vy3tjYJ12Wr2DLp0Uyc5J4tiu1lAadUmF9HtQ7A2KAxwwMsB9J2IbdwBDSH3S2NrKyyISIRQaaucqqbzh+h4QhXby48=
Message-ID: <465C222A.8060003@googlemail.com>
Date: Tue, 29 May 2007 14:52:58 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@bitplanet.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tero Roponen <teanropo@jyu.fi>,
       linux-usb-devel@lists.sourceforge.net,
       "art@usfltd.com" <art@usfltd.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [3/4] 2.6.22-rc3: known regressions
References: <465C188F.9000900@googlemail.com>
In-Reply-To: <465C188F.9000900@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc3.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Suspend

Subject    : 2.6.22-rc1 suspend to RAM problem
References : http://permalink.gmane.org/gmane.linux.power-management.general/5819
Submitter  : Marcus Better <marcus@better.se>
Handled-By : Stefan Richter <stefanr@s5r6.in-berlin.de>
             Kristian Høgsberg <krh@bitplanet.net>
Status     : caused by fw-ohci module



Timers

Subject    : hrtimer overflow bug on 64-bit systems
References : http://lkml.org/lkml/2007/5/24/391
Submitter  : David Miller <davem@davemloft.net>
Status     : problem is being debugged



TTY

Subject    : tty-related oops in latest kernel(s)
References : http://lkml.org/lkml/2007/5/27/104
Submitter  : Tero Roponen <teanropo@jyu.fi>
Status     : problem is being debugged



USB

Subject    : usb hotplug/udev cannot correctly register usb/scanners
References : http://lkml.org/lkml/2007/5/15/205
Submitter  : art@usfltd.com <art@usfltd.com>
Status     : Unknown



Regards,
Michal

--
"Najbardziej brakowało mi twojego milczenia."
-- Andrzej Sapkowski "Coś więcej"

