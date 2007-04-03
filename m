Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbXDCGyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbXDCGyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 02:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbXDCGyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 02:54:14 -0400
Received: from mx10.go2.pl ([193.17.41.74]:51196 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753309AbXDCGyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 02:54:13 -0400
Date: Tue, 3 Apr 2007 08:58:11 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Christian Kujau <evil@g-house.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, malte@g-house.de
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
Message-ID: <20070403065810.GA1832@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704022012300.3963@sheep.housecafe.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02-04-2007 21:41, Christian Kujau wrote:
> 
> Hi there,
> 
> we have serious problems with 2 of our servers: both shiny new amd64 
> dual core, with both 2GB RAM, 32bit kernel+userland (Debian/testing).
> Both servers have 2 NICs, RTL8139 (eth0, irq10) and RTL8169s
> (eth1, irq11).

Hi,

Did you try with 8139cp instead of 8139too?
(Maybe even try some other card to narrow the problem?)
You could also try to test without ehci, if it's possible.

Regards,
Jarek P.
