Return-Path: <linux-kernel-owner+w=401wt.eu-S1763741AbXJNVce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763741AbXJNVce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbXJNVcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:32:25 -0400
Received: from pat.uio.no ([129.240.10.15]:33330 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbXJNVcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:32:25 -0400
Subject: Re: PROBLEM: kernel panic
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Scott Petler <scottp@sonic.net>
Cc: "Doug Whitesell (LKML)" <dcw-kernel@screamingdolphin.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4712835C.5050400@sonic.net>
References: <47114B46.10403@sonic.net>
	 <1192393469.7573.8.camel@heimdal.trondhjem.org>
	 <47127FA8.6040506@sonic.net>
	 <1B7E8ED9-7DA9-41CA-BDF9-219E71AAA905@screamingdolphin.net>
	 <4712835C.5050400@sonic.net>
Content-Type: text/plain
Date: Sun, 14 Oct 2007 17:32:21 -0400
Message-Id: <1192397541.7573.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.083)
X-UiO-Scanned: 77F8B404596C69907FFF35CBADAA2753F6E5C871
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 345 total 4480791 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-10-14 at 14:00 -0700, Scott Petler wrote:
> Doug,
> 
> I thought that might do it, it does seem to work.  I edited the driver 
> line in my xorg.conf
> from nvidia to nv and then,
> <alt><ctrl> F1
> login as root
> /etc/init.d/gdm stop
> /etc/init.d/gdm start
> 
> It came back up with the same flashing crap on the second monitor, so I 
> did it again with
> the 2nd monitor turned off altogether, and I'll see how long it will run 
> on the single monitor
> without the nvidia driver without crashing (maybe forever...).
> 
> Thanks, 
> Scott

Please don't forget to reboot, though. The kernel will remain tainted
until you've rebooted without loading the nvidia module.

Cheers
  Trond

