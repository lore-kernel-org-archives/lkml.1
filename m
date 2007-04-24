Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbXDXJc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbXDXJc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 05:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbXDXJc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 05:32:56 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:51857 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658AbXDXJcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 05:32:55 -0400
Date: Tue, 24 Apr 2007 11:32:53 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Wolfgang Erig <Wolfgang.Erig@gmx.de>, Andi Kleen <ak@suse.de>,
       Oliver Neukum <oneukum@suse.de>, linux-usb-devel@lists.sourceforge.net,
       CIJOML <cijoml@volny.cz>, Markus Rechberger <markus.rechberger@amd.com>,
       v4l-dvb-maintainer@linuxtv.org, Hans-Georg Rist <hg.rist@web.de>,
       perex@suse.cz, alsa-devel@alsa-project.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [1/3] 2.6.21-rc7: known regressions (v2)
Message-ID: <20070424093253.GA1075@erig.dyndns.org>
Mail-Followup-To: Greg KH <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Wolfgang Erig <Wolfgang.Erig@gmx.de>, Andi Kleen <ak@suse.de>,
	Oliver Neukum <oneukum@suse.de>,
	linux-usb-devel@lists.sourceforge.net, CIJOML <cijoml@volny.cz>,
	Markus Rechberger <markus.rechberger@amd.com>,
	v4l-dvb-maintainer@linuxtv.org, Hans-Georg Rist <hg.rist@web.de>,
	perex@suse.cz, alsa-devel@alsa-project.org,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070423214847.GB3468@stusta.de> <20070423221819.GA7218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423221819.GA7218@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 03:18:19PM -0700, Greg KH wrote:
> On Mon, Apr 23, 2007 at 11:48:47PM +0200, Adrian Bunk wrote:
> > This email lists some known regressions in Linus' tree compared to 2.6.20.
> > 
> > If you find your name in the Cc header, you are either submitter of one
> > of the bugs, maintainer of an affectected subsystem or driver, a patch
> > of you caused a breakage or I'm considering you in any other way
> > possibly involved with one or more of these issues.
> > 
> > Due to the huge amount of recipients, please trim the Cc when answering.
> > 
> > 
> > Subject    : gammu no longer works
> > References : http://lkml.org/lkml/2007/4/20/84
> > Submitter  : Wolfgang Erig <Wolfgang.Erig@gmx.de>
> > Status     : unknown
> 
> I've asked for more information about this, and so far am not sure it's
> a real problem.

It is a real problem for me.
I tried this on 2 different boxes with the same behaviour.
No sync between my Nokia mobile and Linux with the latest kernel :(

Which additional information is useful for this problem?

Wolfgang


$ gammu textall --backup backup
Press Ctrl+C to break...
[Gammu            - 1.10.0 built 10:15:07 Mar 13 2007 in gcc 4.1]
[Connection       - "fbuspl2303"]
[Model type       - "3100"]
[Device           - "/dev/ttyUSB0"]
[Run on           - Linux, kernel 2.6.21-rc7-g80d74d51 (#9 SMP Wed Apr 18 21:41:41 CEST 2007)]
[Module           - "1100|1100a|1100b|2650|3100|3100b|3105|3108|3200|3200a|3205|3220|3300|3510|3510i|3530|3589i|3590|3595|5100|5140|5140i|6020|6021|6030|6100|6101|6103|6111|6125|6131|6170|6200|6220|6230|6230i|6233|6234|6270|6280|6310|6310i|6385|6510|6610|6610i|6800|6810|6820|6822|7200|7210|7250|7250i|7260|7270|7360|7370|7600|8310|8390|8910|8910i"]
Setting speed to 19200
I/O possible

