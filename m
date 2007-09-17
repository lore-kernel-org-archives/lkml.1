Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbXIQTO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbXIQTO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbXIQTOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:14:19 -0400
Received: from outbound-mail-57.bluehost.com ([69.89.20.37]:52739 "HELO
	outbound-mail-57.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754951AbXIQTOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:14:18 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Lossy interrupts on x86_64
Date: Mon, 17 Sep 2007 12:13:21 -0700
User-Agent: KMail/1.9.7
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
References: <200709120833.15980.jbarnes@virtuousgeek.org> <200709120929.52217.jbarnes@virtuousgeek.org> <1189616795.4302.1.camel@chaos>
In-Reply-To: <1189616795.4302.1.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709171213.21511.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.88.206.99 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 12, 2007, Thomas Gleixner wrote:
> does it make any difference when you boot the box with:
>
> nohz=off
>
> on the kernel command line ?

Yeah, that makes a difference:  the box hangs when I start receiving 
vblank interrupts instead.  However it's not a hard hang, I think X 
just becomes unresponsive.  I can still hit the power button on the 
laptop and the machine shuts down gracefully, but ctl-alt-delete and 
ctl-alt-backspace don't work.  So X is probably still up and in charge 
of input but may not be getting any more timeslices or something.

So to summarize:

2.6.23-rc5:  works
2.6.23-0.171.rc5.git1.fc8 w/o boot options:  lossy interrupts
2.6.23-0.171.rc5.git1.fc8 nohz=off:  hang when starting 3d apps using
                                     vblank interrupts

Sorry it took so long for me to get back to you, I've been out of range 
for a few days...

Thanks,
Jesse
