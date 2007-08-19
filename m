Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbXHSQdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbXHSQdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 12:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbXHSQdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 12:33:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034AbXHSQc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 12:32:59 -0400
Date: Sun, 19 Aug 2007 09:32:21 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Kevin E <kevin360@yahoo.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Marvell 88E8056 gigabit ethernet controller
Message-ID: <20070819093221.4d3291e9@freepuppy.rosehill.hemminger.net>
In-Reply-To: <283388.84897.qm@web38905.mail.mud.yahoo.com>
References: <20070818121714.GA28247@1wt.eu>
	<283388.84897.qm@web38905.mail.mud.yahoo.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2007 06:59:08 -0700 (PDT)
Kevin E <kevin360@yahoo.com> wrote:

> --- Willy Tarreau <w@1wt.eu> wrote:
> 
> > OK, in this trace, both controllers are on the same
> > bus. The broken
> > one has 'Capabilities: [100] Advanced Error
> > Reporting' the other
> > does not have, and the bridge to this bus has two
> > more capabilities :
> > 'Capabilities: [100] Virtual Channel' and
> > 'Capabilities: [180] Unknown (5)'.
> > 
> > I don't know whether it can jutify a different
> > behaviour. Also, maybe this
> > is caused by a minuscule difference in the BIOS
> > setup ?
> 

The working board has a different version of the Marvell chip:

$ grep Marvell working-MB 
04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 14)
$ grep Marvell broken-MB 
04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 12)

Not sure if that completely explains the problem because the broken chip on my
system is:
06:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 14)

I don't know what the differences are between versions.
