Return-Path: <linux-kernel-owner+w=401wt.eu-S1760246AbXI0XWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246AbXI0XWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXI0XW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:22:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53847 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbXI0XW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:22:28 -0400
Message-ID: <46FC3B27.5090001@zytor.com>
Date: Thu, 27 Sep 2007 16:22:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: jkeating@redhat.com, Joerg Pommnitz <pommnitz@yahoo.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: More E820 brokenness
References: <46FC2BFD.6070200@zytor.com> <20070927223336.GB4755@cosmic.amd.com> <46FC32FE.9070302@zytor.com> <20070927231552.GC4755@cosmic.amd.com>
In-Reply-To: <20070927231552.GC4755@cosmic.amd.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:
> 
> I copied in a 2.6.22 kernel to see that it really did work, and it did.
> But here's the crazy part - I did a dmesg, and it looks like it
> *is* using e820 data, and it looks complete (I see the entire map - 
> including the ACPI and reserved blocks way up high).
> 
> So apparently it was the 2.6.22 code that was buggy, but reading it,
> I don't immediately see how. 
> 

Was this a stock 2.6.22 kernel, or might it have been modified?

There is, of course, also the possibility that triggering the BIOS bug
in your case depends on some delicate combination of input state.

	-hpa
