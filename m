Return-Path: <linux-kernel-owner+w=401wt.eu-S966523AbXEVRz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966523AbXEVRz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761023AbXEVRzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:55:48 -0400
Received: from terminus.zytor.com ([192.83.249.54]:40745 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760665AbXEVRzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:55:48 -0400
Message-ID: <46532E44.4000701@zytor.com>
Date: Tue, 22 May 2007 10:54:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Mike Houston <mikeserv@bmts.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org> <20070520170506.814a38d9.mikeserv@bmts.com> <20070521084549.61a1aa71@freepuppy> <20070521131055.0017404f.mikeserv@bmts.com> <20070521103755.51b954e1@freepuppy> <20070521225806.bb18d589.mikeserv@bmts.com> <20070521213146.3e220a44@freepuppy> <4652733F.4030708@garzik.org> <20070521214255.3dc36445@freepuppy> <alpine.LFD.0.98.0705212153220.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705212153220.3890@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> I can't really see that being a real problem in this day and age of PCI-X 
> etc, but it _used_ to be a possible issue a decade ago. Maybe you've found 
> a case where it matters even on modern hardware? We occasionally used to 
> set the PCI latency timer to make people happy.
> 
> (Not that I'm convinced it even has any semantic meaning on a modern PCI 
> system..)
> 

The PCI latency counters matter as long as you're talking a PCI or PCI-X
bus.  It matters not one iota on anything that pretends to be a PCI bus
but isn't, i.e. PCI Express, HyperTransport, etc.

	-hpa
