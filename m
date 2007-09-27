Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbXI0Wrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbXI0Wrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbXI0Wrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:47:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41204 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbXI0Wri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:47:38 -0400
Message-ID: <46FC32FE.9070302@zytor.com>
Date: Thu, 27 Sep 2007 15:47:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: jkeating@redhat.com, Joerg Pommnitz <pommnitz@yahoo.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: More E820 brokenness
References: <46FC2BFD.6070200@zytor.com> <20070927223336.GB4755@cosmic.amd.com>
In-Reply-To: <20070927223336.GB4755@cosmic.amd.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:
> 
> Breaks on the Geode - original behavior.
> 
> I think that having boot_prams.e820_entries != 0 makes the kernel
> assume the e820 data is correct.
> 

Okay, now I'm utterly baffled how 2.6.22 ever worked on this Geode,
because this, to the best of my reading, mimics the 2.6.22 behavior
exactly.  DID IT REALLY, and/or did you make any kind of configuration
changes?

>> I want to emphasize that this is seriously broken.  Using a partial e820
>> map could have disastrous results, since the kernel will have partial
>> memory map information and not know about reserved areas, etc.  Part of
>> me feels that the right thing to do is what the current git kernel does
>> -- either fall back to e801, or stop and error.
> 
> I'm inclined to agree.  

Arguably the right thing to do is to find the responsible BIOS engineer
and shoot them, but that's hard to do without robotics.

	-hpa



