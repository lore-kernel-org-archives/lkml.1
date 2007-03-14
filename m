Return-Path: <linux-kernel-owner+w=401wt.eu-S964808AbXCNXQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808AbXCNXQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 19:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964804AbXCNXQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 19:16:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45285 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964790AbXCNXQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 19:16:52 -0400
Message-ID: <45F8825F.3030904@garzik.org>
Date: Wed, 14 Mar 2007 19:16:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, michal.k.k.piotrowski@gmail.com,
       linux-ide@vger.kernel.org, tglx@linutronix.de,
       shemminger@linux-foundation.org, mlord@pobox.com,
       linux-pm@lists.osdl.org
Subject: Re: [PATCH/RFC] PCI prepare/activate instead of enable to avoid IRQ
 storm and rogue DMA access
References: <20070314152302.GB15600@htj.dyndns.org> <20070314215605.GA7194@flint.arm.linux.org.uk> <45F87863.9040408@garzik.org> <20070314225818.GB7194@flint.arm.linux.org.uk>
In-Reply-To: <20070314225818.GB7194@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> In any case, relying on such a new control bit to implement this kind
> of functionality would result in a very hit and miss result; Linux

How does Tejun's patch or thesis rely on this new control bit?  He 
explicitly mentions DISABLE_INTX variability...

	Jeff


