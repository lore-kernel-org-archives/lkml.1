Return-Path: <linux-kernel-owner+w=401wt.eu-S1751659AbZL2VFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbZL2VFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZL2VFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:05:53 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56544 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751051AbZL2VFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:05:52 -0500
Date: Tue, 29 Dec 2009 21:08:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Regression, bisected] Receive failure in et131x.
Message-ID: <20091229210822.2a6a5f80@lxorguk.ukuu.org.uk>
In-Reply-To: <20091229180005.GA23030@emergent.ellipticsemi.com>
References: <20091229180005.GA23030@emergent.ellipticsemi.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Dec 2009 13:00:05 -0500
Nick Bowler <nbowler@elliptictech.com> wrote:

> Continuing the theme from the last release cycle -- my PCI-express
> et131x card (which works in 2.6.32) fails in the latest Linus git.  The
> card works at first (DHCP and NFS mounts during bootup are OK) but
> quickly fails once any reasonable traffic is put through it.  Transmit
> seems to continue to work after a failure, but receive is mostly dead
> forever -- the occasional frame appears to make it through.  The kernel
> log contains many messages of the following form:
> 
> et131x 0000:02:00.0: NICRxPkts PSR Entry 1546 indicates length of 12920 and/or bad bi(614)
> et131x 0000:02:00.0: NICRxPkts PSR Entry 1547 indicates length of 27745 and/or bad bi(92)
> et131x 0000:02:00.0: NICRxPkts PSR Entry 1548 indicates length of 30064 and/or bad bi(116)

Thanks - I'll beat that one over the head Jan 2nd and get it back into
order. What setup are you using and at what speed ?

Alan
