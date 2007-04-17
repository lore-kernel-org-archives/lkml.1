Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbXDQAFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbXDQAFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 20:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbXDQAFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 20:05:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46977
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbXDQAFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 20:05:02 -0400
Date: Mon, 16 Apr 2007 17:05:04 -0700 (PDT)
Message-Id: <20070416.170504.02298047.davem@davemloft.net>
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@SteelEye.com, ema@debian.org
Subject: Re: Major qla2xxx regression on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070416234705.GA15937@dmccrory-d810.qlogic.org>
References: <20070416232851.GA15840@dmccrory-d810.qlogic.org>
	<20070416.164111.32625690.davem@davemloft.net>
	<20070416234705.GA15937@dmccrory-d810.qlogic.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Mon, 16 Apr 2007 16:47:05 -0700

> Dave, according to your earlier emails, the qla2xxx driver worked
> 'fine' in driver versions before commit
> 7aef45ac92f49e76d990b51b7ecd714b9a608be1.  If that were the case, then
> you would have seen the warning messages:
> 
> 	...
> 	qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
> 		"invalid -- WWPN) defaults.\n");

I have in fact seen the message several times and that messages gives
me no reason to believe something needs to be fixed.

It should have said "PLEASE REPORT THIS to drivers@qlogic.com" or
something similar to indicate the severity better.

"An invalid WWPN, what's that?" said the user. :)

How about "FC IDs may conflict and cause miscommunication!  Please
report to driver author so this can be fixed!" or similar?
