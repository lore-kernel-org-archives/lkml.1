Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbXHaNLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbXHaNLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbXHaNKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:10:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42131 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbXHaNKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:10:48 -0400
Message-ID: <46D81354.3010107@garzik.org>
Date: Fri, 31 Aug 2007 09:10:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Petko Manolov <petkan@users.sourceforge.net>
Subject: Re: [git patches] net driver fixes
References: <20070730212333.GA8049@havoc.gtf.org> <alpine.LFD.0.999.0707310349460.17287@enigma.security.iitk.ac.in> <46AE6861.50004@garzik.org> <alpine.LFD.0.999.0707310425360.17287@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0707310425360.17287@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> 
> On Mon, 30 Jul 2007, Jeff Garzik wrote:
> 
>> true, we should just remove the dev==NULL check
> 
> Patch below:
> 
> [PATCH] nmclan_cs: Remove bogus (dev==NULL) check in mace_interrupt()
> 
> The (dev == NULL) check in drivers/net/pcmcia/nmclan_cs.c:mace_interrupt()
> handler is always false, so let's remove it.
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
> 
> ---
> 
>  drivers/net/pcmcia/nmclan_cs.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)

ACK, but patch does not apply to netdev-2.6.git#upstream alas


