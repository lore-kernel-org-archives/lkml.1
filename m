Return-Path: <linux-kernel-owner+w=401wt.eu-S1031003AbXDPWIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031003AbXDPWIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031006AbXDPWIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:08:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32839
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031003AbXDPWIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:08:45 -0400
Date: Mon, 16 Apr 2007 15:08:46 -0700 (PDT)
Message-Id: <20070416.150846.45744461.davem@davemloft.net>
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@SteelEye.com, ema@debian.org
Subject: Re: Major qla2xxx regression on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070416211049.GC13590@andrew-vasquezs-computer.local>
References: <20070416.123743.07452378.davem@davemloft.net>
	<20070416200857.GH10822@andrew-vasquezs-computer.local>
	<20070416211049.GC13590@andrew-vasquezs-computer.local>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Mon, 16 Apr 2007 14:10:49 -0700

> Ok, how about the following patch based on the one you posted which
> adds the codes to retrieve the WWPN/WWNN from firmware on SPARC, and
> also adds the module-parameter override I mentioned above.
> 
> Perhaps the module-parameter should be set to non-zero in the case of
> SPARC, to take care of your system configurations?

I think it should default to non-zero always, in fact the option
is completely pointless.

The guy who hits this had a system which worked previously, and you're
explicitly breaking it.  That's wrong.

How can you not see that this quality of implementation decision
you're making stinks?
