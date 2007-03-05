Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbXCEEBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbXCEEBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXCEEBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:01:37 -0500
Received: from rtr.ca ([64.26.128.89]:2556 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbXCEEBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:01:36 -0500
Message-ID: <45EB961D.6030808@rtr.ca>
Date: Sun, 04 Mar 2007 23:01:33 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Pavel Machek <pavel@ucw.cz>,
       Marcel Holtmann <marcel@holtmann.org>, linux-pm@lists.osdl.org,
       maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>, Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Albert Hopkins <kernel@marduk.letterboxes.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org
Subject: Re: [1/6] 2.6.21-rc2: known regressions
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de>
In-Reply-To: <20070305015031.GF3441@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>
> Subject    : Bluetooth RFComm locks up the machine  (device_move() related)
> References : http://lkml.org/lkml/2007/3/4/64
> Submitter  : Mark Lord <lkml@rtr.ca>
> Caused-By  : Marcel Holtmann <marcel@holtmann.org>
>              commit c1a3313698895d8ad4760f98642007bf236af2e8
> Status     : unknown

A 2-line patch exists for fs/sysfs/dir.c to address this.
Waiting on Greg to apply it or substitute something prettier.  ;)

Cheers
