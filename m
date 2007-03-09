Return-Path: <linux-kernel-owner+w=401wt.eu-S1767440AbXCIRip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767440AbXCIRip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXCIRip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:38:45 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58192 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbXCIRio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:38:44 -0500
Message-ID: <45F19BA1.3090408@garzik.org>
Date: Fri, 09 Mar 2007 12:38:41 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, john.ronciak@intel.com,
       jesse.brandeburg@intel.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] e1000: FIX: be ready for incoming irq at pci_request_irq
References: <20070306165721.27434.23796.stgit@localhost.localdomain> <45F18F7C.3030801@garzik.org> <45F1954D.4000506@intel.com>
In-Reply-To: <45F1954D.4000506@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Personally, I think this is really really needed. I'm surprised that you 
> already didn't push this considering Andrew pulled this into -mm 
> immediately.


Since it affects a fragile area of e1000 for all [e1000] users, I much 
prefer to err on the side of caution.  I have a history of pulling 
wide-impact fixes like this, late in -rc cycle, and having yet more 
breakage appear.

But if Andrew or Linus disagree, feel free to override me.  This is just 
area where I am intentionally over-cautious.

	Jeff




