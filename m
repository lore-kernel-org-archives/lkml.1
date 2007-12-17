Return-Path: <linux-kernel-owner+w=401wt.eu-S934861AbXLQWce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934861AbXLQWce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbXLQWc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:32:26 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35916 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754201AbXLQWcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:32:25 -0500
Date: Mon, 17 Dec 2007 17:32:25 -0500
To: Oliver Joa <oliver@j-o-a.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to Switch DMA off for only one Harddisk at Kernelboot
Message-ID: <20071217223225.GF2310@csclub.uwaterloo.ca>
References: <4765690C.6010605@j-o-a.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4765690C.6010605@j-o-a.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 07:06:04PM +0100, Oliver Joa wrote:
> how can I tell the kernel not to probe DMA for a specific harddisk (e.g. 
> hda). My first Drive (hda) is a Compact-Flash Card which can not do DMA. 
> The kernel tries at boot to switch to DMA but fails. If I use ide=nodma, 
> the kernel boots about 2 minutes faster, but then I can not switch on 
> DMA for the second Drive (hdc) which is a normal Harddisk. Do I have to 
> live with this 2 minutes waiting time or is there another solution? I 
> did not find any kernel-parameter for this purpose.
> 
> Sorry if I ask here, but I can not find any solution, and I asked 
> already in other groups.

Isn't it more a matter of having a CF card that does do DMA and a
controller that does DMA, but a CF to IDE adapter that does not do DMA?

If it is really a case of a CF card that claims to do DMA but is
unstable if you try (I have found one model that does so), then it
should simply be added to the ide dma blacklist instead.

I blacklisted 'SMART CF' on my system since they have random read errors
and other i/o errors whenever DMA is enabled (while other cards work
fine with DMA enabled).  They claim to do DMA, but sure don't seem to do
so reliably on this system.  SiliconDrive CF works perfectly with DMA on
the same system.

--
Len Sorensen
