Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbXGHPnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbXGHPnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 11:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbXGHPm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 11:42:56 -0400
Received: from mail.queued.net ([207.210.101.209]:3978 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbXGHPm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 11:42:56 -0400
Date: Sun, 8 Jul 2007 11:44:43 -0400
From: Andres Salomon <dilinger@queued.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jordan Crouse <jordan.crouse@amd.com>, info-linux@geode.amd.com,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz, tsylla@gmail.com
Subject: Re: UNS: Re: [PATCH] PCI: do not delay when changing power states
 on Geode
Message-Id: <20070708114443.4f2ee65e.dilinger@queued.net>
In-Reply-To: <20070706110518.13399132@the-village.bc.nu>
References: <20070705221351.97d14df0.dilinger@queued.net>
	<20070706110518.13399132@the-village.bc.nu>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007 11:05:18 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Thu, 5 Jul 2007 22:13:51 -0400
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > Geode hardware requires no delay when doing power transition for PCI;
> > the board doesn't even have a real PCI bus.  Thanks to Tom Sylla for
> > pointing this out.  We can save precious milliseconds when changing power
> > states to D3hot by getting rid of this delay.
> > 
> > We do this as a PCI quirk.
> 
> NAK
> 
> These systems may have other components on them which require the proper
> transition times and the CS5530 supports external real PCI devices.
> 
> Alan

You're right; I munged the description.  Turns out the patch is wrong
anyways, though (whether the delay is necessary or not turns out to be
firmware dependent).


-- 
Andres Salomon <dilinger@queued.net>
