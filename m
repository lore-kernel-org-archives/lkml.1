Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZBIKRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZBIKRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbZBIKRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:17:38 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:44970 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZBIKRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:17:38 -0500
Date: Mon, 9 Feb 2009 11:17:30 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: George Spelvin <linux@horizon.com>
Cc: udovdh@xs4all.nl, linux-kernel@vger.kernel.org, LinuxPPS@ml.enneenne.com
Message-ID: <20090209101730.GM7975@enneenne.com>
Mail-Followup-To: George Spelvin <linux@horizon.com>, udovdh@xs4all.nl,
	linux-kernel@vger.kernel.org, LinuxPPS@ml.enneenne.com
References: <20090206142231.22425.qmail@science.horizon.com> <20090206143703.GC7975@enneenne.com> <20090206144752.5195.qmail@science.horizon.com> <20090206145553.GD7975@enneenne.com> <20090206145932.10638.qmail@science.horizon.com> <20090206152156.GE7975@enneenne.com> <20090206225326.14093.qmail@science.horizon.com> <20090208004914.21448.qmail@science.horizon.com> <498E712F.7080206@xs4all.nl> <20090208060938.25184.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090208060938.25184.qmail@science.horizon.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [LinuxPPS] LinuxPPS kernel interface
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 01:09:38AM -0500, George Spelvin wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> > Interesting ideas, thanks for the input.
> >
> > I think I must mention  that we also must strive for kernel inclusion.
> > Kernel inclusion will broaden our exposure.
> > This means we have to get rid of the issues blocking inclusion.
> > (see a query like http://marc.info/?l=linux-kernel&w=2&r=1&s=pps&q=b for 
> > related posts)
> >
> > What do you think?
> 
> I agree, that's the goal.  But it's also important to get the
> interface right, preferably before publishing it to world+dog.
> 
> And then there are little things like the fact that an important header
> file like timepps.h probably shouldn't live in Documentation/pps...
> 
> For example, here's a patch, on top of the previous series, that
> gets rid of the timeout argument to PPS_FETCH:

Please, note that such file is _not_ into kernel proposed patch.

First we should get inclusion of core code, then we can discuss about
userland interface and other related stuff.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
