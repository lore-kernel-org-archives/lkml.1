Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbXKUVF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbXKUVF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 16:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbXKUVFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 16:05:51 -0500
Received: from main.gmane.org ([80.91.229.2]:55780 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbXKUVFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 16:05:50 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: network driver usage count
Date: Wed, 21 Nov 2007 13:04:45 -0800
Organization: Linux Foundation
Message-ID: <20071121130445.569d2176@freepuppy.rosehill>
References: <87hcjf9yd4.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <87hcjf9yd4.fsf@tac.ki.iif.hu>
X-Newsreader: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 20:45:11 +0100
Ferenc Wagner <wferi@niif.hu> wrote:

> Hi!
> 
> Under 2.6.23.1, my lsmod output shows this:
> 
> $ lsmod | grep tg3
> tg3                   100580  0 
> 
> The usage count is zero, even though it drives my two physical
> interfaces:
> 
> $ ls -l /sys/class/net/eth-gb?/device/driver
> lrwxrwxrwx 1 root root 0 2007-11-21 19:58 /sys/class/net/eth-gb1/device/driver -> ../../../bus/pci/drivers/tg3
> lrwxrwxrwx 1 root root 0 2007-11-21 19:58 /sys/class/net/eth-gb2/device/driver -> ../../../bus/pci/drivers/tg3
> 
> These interfaces are up and bonded together, but that doesn't seem to
> matter at all.  I also checked other machines, the network driver
> (tg3, e1000) usage counts are always zero under various recent 2.6
> kernels, but nonzero under 2.4.21 for example.
> 
> And really, the module could be removed, cutting my ssh session. :)
> 
> Was this made possible intentionally?  If yes, why?

Yes, so devices can be removed at anytime.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

