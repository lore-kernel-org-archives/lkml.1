Return-Path: <linux-kernel-owner+w=401wt.eu-S1765560AbXEVRT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765560AbXEVRT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbXEVRTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:19:48 -0400
Received: from smtp.osdl.org ([207.189.120.12]:44275 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbXEVRTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:19:47 -0400
Date: Tue, 22 May 2007 10:19:26 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Mike Houston <mikeserv@bmts.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
Message-ID: <20070522101926.481d3ec7@freepuppy>
In-Reply-To: <alpine.LFD.0.98.0705212153220.3890@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
	<20070520170506.814a38d9.mikeserv@bmts.com>
	<20070521084549.61a1aa71@freepuppy>
	<20070521131055.0017404f.mikeserv@bmts.com>
	<20070521103755.51b954e1@freepuppy>
	<20070521225806.bb18d589.mikeserv@bmts.com>
	<20070521213146.3e220a44@freepuppy>
	<4652733F.4030708@garzik.org>
	<20070521214255.3dc36445@freepuppy>
	<alpine.LFD.0.98.0705212153220.3890@woody.linux-foundation.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 22:04:26 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 21 May 2007, Stephen Hemminger wrote:
> >
> > AHCI on this motherboard doesn't seem to use MSI. The problems occur
> > even if I boot with nomsi.
> 
> Have you tried playing with PCI latency counters etc? 
> 
> Maybe the SATA/AHCI thing is better at saturating the bus, and the sky2 
> hardware gets upset if it has overlong DMA access latencies due to some 
> other controller keeping the bus busy with a long burst access?
> 
> I can't really see that being a real problem in this day and age of PCI-X 
> etc, but it _used_ to be a possible issue a decade ago. Maybe you've found 
> a case where it matters even on modern hardware? We occasionally used to 
> set the PCI latency timer to make people happy.
> 
> (Not that I'm convinced it even has any semantic meaning on a modern PCI 
> system..)
> 
> 		Linus

The device in question is PCI Express, and the latency has no meaning (at
least in vendor spec).

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
