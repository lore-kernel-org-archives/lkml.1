Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbXDQClN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbXDQClN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 22:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbXDQClN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 22:41:13 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:20540 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbXDQClM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 22:41:12 -0400
Date: Mon, 16 Apr 2007 19:41:07 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: David Miller <davem@davemloft.net>, Seokmann Ju <seokmann.ju@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@SteelEye.com, ema@debian.org
Subject: Re: Major qla2xxx regression on sparc64
Message-ID: <20070417024107.GE16469@dmccrory-d810.qlogic.org>
References: <20070416232851.GA15840@dmccrory-d810.qlogic.org> <20070416.164111.32625690.davem@davemloft.net> <20070416234705.GA15937@dmccrory-d810.qlogic.org> <20070416.170504.02298047.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416.170504.02298047.davem@davemloft.net>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 17 Apr 2007 02:40:55.0346 (UTC) FILETIME=[D2826120:01C78099]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, David Miller wrote:

> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Date: Mon, 16 Apr 2007 16:47:05 -0700
> 
> > Dave, according to your earlier emails, the qla2xxx driver worked
> > 'fine' in driver versions before commit
> > 7aef45ac92f49e76d990b51b7ecd714b9a608be1.  If that were the case, then
> > you would have seen the warning messages:
> > 
> > 	...
> > 	qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
> > 		"invalid -- WWPN) defaults.\n");
> 
> I have in fact seen the message several times and that messages gives
> me no reason to believe something needs to be fixed.
> 
> It should have said "PLEASE REPORT THIS to drivers@qlogic.com" or
> something similar to indicate the severity better.
> 
> "An invalid WWPN, what's that?" said the user. :)
> 
> How about "FC IDs may conflict and cause miscommunication!  Please
> report to driver author so this can be fixed!" or similar?

That verbiage sounds fine -- so would you consider the previous patch
I submitted (with module parameter) along with the wording above?

I'm in transit for a redeye to NY so I won't be able to modify the
patch, If you would be amenable to the above, Seokmann, could you
rework the patch?
