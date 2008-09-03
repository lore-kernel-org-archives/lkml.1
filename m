Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYICOBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYICOBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYICOBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:01:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60004 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYICOBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:01:41 -0400
Message-ID: <48BE98BF.4020507@garzik.org>
Date: Wed, 03 Sep 2008 10:01:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: torvalds@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ahci: Fix long standing Marvell regressions
References: <20080903000538.7500eaf8@lxorguk.ukuu.org.uk>	<48BDCF09.7000603@garzik.org>	<20080903142941.3f25d235@lxorguk.ukuu.org.uk> <20080903144834.35276de7@lxorguk.ukuu.org.uk>
In-Reply-To: <20080903144834.35276de7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> And here's a rev 3
> 
> - Fix the option so it works both ways
> - We can using the 6145 detect PATA enabled so implement a facility in
> pata_marvell to punt to AHCI if disabled
> 
> We can't automate that for the other devices as we don't actually know
> how to check the PATA port on them.

Nice... superceding your rev 2 in my queue for 2.6.27-rc.


