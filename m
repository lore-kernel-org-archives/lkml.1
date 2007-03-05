Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbXCEEDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbXCEEDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXCEEDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:03:46 -0500
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:33708 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbXCEEDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:03:44 -0500
Date: Sun, 4 Mar 2007 20:58:59 -0700
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mathieu =?iso-8859-1?Q?B=E9rard?= <Mathieu.Berard@crans.org>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Fabio Comolli <fabio.comolli@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Janosch Machowinski <jmachowinski@gmx.de>,
       Lukas Hejtmanek <xhejtman@fi.muni.cz>, Meelis Roos <mroos@linux.ee>,
       Olivier Mondoloni <darkcore71@yahoo.fr>,
       Thomas Renninger <trenn@suse.de>, Robert Moore <robert.moore@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [3/6] 2.6.21-rc2: known regressions
Message-ID: <20070305035859.GA29234@ellpspace.math.ualberta.ca>
Reply-To: michal@harddata.com
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015036.GH3441@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305015036.GH3441@stusta.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 02:50:36AM +0100, Adrian Bunk wrote:
> This email lists some known regressions in 2.6.21-rc2 compared to 2.6.20
> that are not yet fixed in Linus' tree.
....
> Subject    : kernels fail to boot with drives on ATIIXP controller
> References : https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229621
> Submitter  : Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
> Status     : unknown

Alan added comment to my posting that my problems are caused by
messed up IRQ routing on that box I tried.  Indeed, I can boot
kernel 2.6.20-1.2962.fc7, which really is 2.6.21-rc2, provided
I will use 'acpi=off irqpoll'.  Anything else and a boot silently
dies if 'acpi=off' is skipped or is not finding disk if 'irqpoll'
is missing.

Somehow 2.6.19 is booting on the same hardware without "valliant
efforts"; OTOH 'ahci' driver was not used there.

    Michal
