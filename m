Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbYAQU74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbYAQU74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbYAQU7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:59:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55757 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbYAQU7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:59:47 -0500
Date: Thu, 17 Jan 2008 12:57:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Andreas Herrmann3 <andreas.herrmann3@amd.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
 fixes
In-Reply-To: <478FBBA9.4070300@zytor.com>
Message-ID: <alpine.LFD.1.00.0801171255580.14959@woody.linux-foundation.org>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <478FBBA9.4070300@zytor.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jan 2008, H. Peter Anvin wrote:
> > >   swapper:1 conflicting cache attribute c0403000-c0404000 uncached<->default
> > >   ACPI: PCI interrupt for device 0000:00:12.0 disabled
> 
> The correct behaviour probably would be to go with the most restrictive
> caching behaviour, i.e. uncached in this case.

Well, the sad part is that in this case, uncached is the SAME THING as 
default. 

So it's not like there is any actual real conflict, other than in a PAT 
confusion thing.

			Linus
