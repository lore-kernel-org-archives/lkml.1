Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbXEPJ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbXEPJ3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXEPJ3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:29:12 -0400
Received: from canuck.infradead.org ([209.217.80.40]:56328 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXEPJ3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:29:10 -0400
Date: Wed, 16 May 2007 02:27:01 -0700
From: Greg KH <greg@kroah.com>
To: Vasily Averin <vvs@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: [Devel] [patch i2o 5/6] i2o_proc files permission
Message-ID: <20070516092701.GA22155@kroah.com>
References: <4649AA6C.2080808@sw.ru> <4649ABC9.6020605@sw.ru> <4649AEC5.1060501@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4649AEC5.1060501@sw.ru>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 04:59:49PM +0400, Vasily Averin wrote:
> I would add:
> I've reported about this issue some time ago to security@kernel.org
> How this lockup can be reproduced:
> - boot the kernel,
> - load i2o_proc module
> - login as user and read all entries in /proc/i2o/ directory
> 
> My testnode hangs when I try to read any file from /proc/i2o/iop0/030/
> directory: I have the shell prompt and even can try to start any new command
> which hangs due exec is not works.
> Node is pingable, but I cannot login to it nor via ssh neither from local
> console. Magic Sysrq keys are works. Kernel space software watchdog module
> works OK. But all the new commnds hangs, looks like i2o controller is in coma.
> 
> Greg KH wrote:
> And I'd classify this a "low" security issue, as you have to be root to
> load the i2o_proc module, and I doubt that the distros automatically
> load it.

Yeah, I said it as I didn't see a "simple" way to fix it at the time.
If you have solved this now with this patch, I have no objection to it.

thanks,

greg k-h
