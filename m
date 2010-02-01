Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0BATdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:33:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53429 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab0BATdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:33:15 -0500
Message-ID: <4B672C31.9070302@zytor.com>
Date: Mon, 01 Feb 2010 11:32:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Simek <michal.simek@petalogix.com>,
       LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>
Subject: Re: Split 'flush_old_exec' into two functions - 221af7f87b97431e3ee21ce4b0e77d5411cf1549
References: <4B66DE64.8010101@petalogix.com> <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 07:57 AM, Linus Torvalds wrote:
> 
> That said, Microblaze is not one of the architectures I would have 
> expected to have problems. It has one of the most straightforward 
> "flush_thread()" implementations in the whole kernel (it's a no-op ;), and 
> that's where most of the hacky things were for the architectures that 
> needed the change. And it has no "arch_pick_mmap_layout()" issues or 
> anything else that tends to depend on personality bits or whatever.
> 
> Microblaze is a no-MMU platform, isn't it? Which binary format does it 
> use? It looks like _some_ binaries work (it seems to happily be running a 
> shell to actually do those startup scripts) while others have problems. Is 
> there a difference between "/bin/sh" and the binaries that seem to be 
> problematic (like /bin/mount and /bin/ifup).
> 
> Are the failing binaries all setuid ones, for example? Or shared vs 
> non-shared? Or ELF vs FLAT or whatever?
> 

Another thing... it looks like you [Michal] is running a test image
under Qemu... could you perhaps point us to that image or another test
image which reproduces the problem?

Nothing like having a hands-on testcase...

	-hpa

