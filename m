Return-Path: <linux-kernel-owner+w=401wt.eu-S966053AbXDIQAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966053AbXDIQAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966055AbXDIQAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:00:21 -0400
Received: from iasrv1.idleaire.net ([63.78.244.180]:45969 "EHLO
	iasrv1.idleaire.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966053AbXDIQAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:00:20 -0400
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
From: Dave Dillow <dave@thedillows.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, ray-gmail@madrabbit.org,
       Ingo Molnar <mingo@elte.hu>, amanda-hackers@amanda.org,
       amanda-users@amanda.org
In-Reply-To: <200704091133.44684.gene.heskett@gmail.com>
References: <200704010100.19016.gene.heskett@verizon.net>
	 <1175488272.3161.28.camel@obelisk.thedillows.org>
	 <1175661256.31439.23.camel@obelisk.thedillows.org>
	 <200704091133.44684.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 11:59:45 -0400
Message-Id: <1176134386.4767.4.camel@dillow.idleaire.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-1.fc5.5) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Apr 2007 15:59:17.0136 (UTC) FILETIME=[06E57900:01C77AC0]
X-TM-AS-Product-Ver: SMEX-7.0.0.1345-3.6.1039-14858.000
X-TM-AS-Result: No--10.629500-8.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 11:33 -0400, Gene Heskett wrote:
> >I'm not sure I could argue for that to be reverted, so here's a possible
> >workaround for Fedora -- completely untested.
> >
> >Add the following to /etc/modprobe.conf:
> >options dm_mod major=253
> 
> This does not work.

Hmm, it worked for me when I tested it this weekend. I did use 'dm-mod'
instead of 'dm_mod'.

This was using it on FC6, and LVM isn't loaded until after the initrd
finishes, as I don't use LVM at all. Everything was compiled as modules.

I cannot vouch for it working in the initrd, as I don't have a machine
that uses LVM for the root.

-- 
Dave Dillow <dave@thedillows.org>

