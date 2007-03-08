Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbXCHPME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbXCHPME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXCHPMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:12:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:32035 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbXCHPMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:12:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QwqdGK+e/Xtq2OQ2pDo7Wlf5PKXB6zyP2s64cTwUdD218iZLeBee3nNjC7wAW3klMchTxaLl+tUB8qnseufaSIqPvo1fz3hRxm1jFgo42tq09QxVPbQSg+GTPXkF7I2DLgrkvn1myvrnzqSdZDqkItAhIbm2hzO4GS8X7MBOcKk=
Message-ID: <b6a2187b0703080711g47fe734dmfe5d6b03e13275d6@mail.gmail.com>
Date: Thu, 8 Mar 2007 23:11:58 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>, pavel@suse.cz,
       linux-pm@lists.osdl.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
       luming.yu@intel.com, "Arkadiusz Miskiewicz" <arekm@maven.pl>,
       "Konstantin Karasyov" <konstantin.a.karasyov@intel.com>, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net,
       "Thomas Meyer" <thomas.mey@web.de>, "Meelis Roos" <mroos@linux.ee>,
       "Alexey Starikovskiy" <alexey.y.starikovskiy@linux.intel.com>,
       "Janosch Machowinski" <jmachowinski@gmx.de>,
       vladimir.p.lebedev@intel.com,
       "Ash Milsted" <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <20070308123143.GF5149@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015034.GG3441@stusta.de>
	 <20070308123143.GF5149@mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Michael S. Tsirkin <mst@mellanox.co.il> wrote:
> > Quoting Adrian Bunk <bunk@stusta.de>:
> > Subject: [2/6] 2.6.21-rc2: known regressions
> >
> > Subject    : ThinkPad T60: no screen after suspend to RAM
> > References : http://lkml.org/lkml/2007/2/22/391
> > Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> > Status     : unknown
>
> Here's the status with -rc3: better, but still does not work as well as 2.6.20.

> 3. When I switch to X (CTRL-ALT-F7), X hangs after drawing a couple of windows
>    after waiting for some 10 min, I rebooted.
>    no new messages showed up in /var/log/messages

In my case, I can "suspend" and "resume", but seems the clock died
after resume. "date" always returns the same time! I had to disable
CONFIG_NO_HZ and CONFIG_SYSFS_DEPRECATED in order to suspend.

Try to execute "date" and see if it changes after resume.

Thanks,
Jeff.
