Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbZDUB2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbZDUB2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZDUB14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:27:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53868 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbZDUB1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:27:55 -0400
Message-ID: <49ED2088.9090703@zytor.com>
Date: Mon, 20 Apr 2009 18:25:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections
 -fdata-sections
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain> <alpine.DEB.1.10.0904202010220.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Are there any advantages outside of the size things?
> 
> Do we end up packing data better? 
> 
> I'd like to have some more champions of this code, in other words.
> 
> I'd be ok with merging it, but I haven't really gotten a strong feeling 
> that anybody is going to enable it or use it.
> 

It may be a long haul to get people to actually use it, but there is a
fairly major advantage near the end, and that is that we can structure
the source code in a way that makes sense for reading it, rather than
what will end up using what.

Assuming it does work correctly.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

