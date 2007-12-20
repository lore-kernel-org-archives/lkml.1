Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbXLTKlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbXLTKlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 05:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbXLTKkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 05:40:47 -0500
Received: from mx1.slu.se ([130.238.96.70]:52011 "EHLO mx1.slu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbXLTKkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 05:40:45 -0500
X-Greylist: delayed 1426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2007 05:40:45 EST
From: Robert Olsson <Robert.Olsson@data.slu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18282.15185.592112.550961@robur.slu.se>
Date: Thu, 20 Dec 2007 10:52:17 +0100
To: David Miller <davem@davemloft.net>
Cc: gallatin@myri.com, joonwpark81@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org
Subject: Re: [RFC] net: napi fix
In-Reply-To: <20071212.093819.205755031.davem@davemloft.net>
References: <47601A73.5010804@myri.com>
	<20071212.093819.205755031.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Miller writes:

 > > Is the netif_running() check even required?
 > 
 > No, it is not.
 > 
 > When a device is brought down, one of the first things
 > that happens is that we wait for all pending NAPI polls
 > to complete, then block any new polls from starting.

 Hello!

 Yes but the reason was not to wait for all pending polls to
 complete so a server/router could be rebooted even under high-
 load and DOS. We've experienced some nasty problems with this.

 Cheers.
					--ro
