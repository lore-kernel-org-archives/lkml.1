Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbYKOS1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbYKOS1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 13:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYKOS06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 13:26:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44324 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYKOS06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 13:26:58 -0500
Date: Sat, 15 Nov 2008 19:36:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>, Mikael Pettersson <mikpe@it.uu.se>,
       Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
       Jiri Benc <jbenc@suse.cz>, Vilem Marsik <vmarsik@suse.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       eranian@googlemail.com
Subject: Re: Oprofile : need to adjust PC by 16 bytes
Message-ID: <20081115183627.GL3810@one.firstfloor.org>
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz> <20081113212446.GA5694@elte.hu> <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz> <20081113213744.GA8429@elte.hu> <491CA0DC.8070405@cosmosbay.com> <491D987F.1000301@cosmosbay.com> <18717.44751.459961.277998@harpo.it.uu.se> <491DB391.2040701@cosmosbay.com> <20081114175056.GK3810@one.firstfloor.org> <491EF942.1090709@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <491EF942.1090709@cosmosbay.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 05:30:58PM +0100, Eric Dumazet wrote:
> Andi Kleen a écrit :
> >>>And no, blindly subtracting 16 from IP is not a fix.
> >>Who mentioned a fix ? I am only giving more fuel to Intel guys so they
> >>hopefully can give us a working oprofile.
> >
> >You would need to implement PEBS support to avoid that problem. But it's a 
> >big
> >task. perfmon2 implements it already.
> >
> 
> Thanks for the information.
> 
> Hum, so I grabbed perfmon2 git tree, installed various tools...
> 
> I am quite new to pfmon and tried :
> 
> # pfmon --system-wide
> sizeof=64 44
> <press ENTER to stop session>
> 
> Then started "tbench 8", and got a kernel panic after 6 seconds.
> 
> 
> I was using oprofile like this
> 
> opcontrol --vmlinux=/path/vmlinux --start
> // doing some benchmarking...
> opreport -l vmlinux | head -n 40
> 
> 
> What would be a working equivalent for perfmon2 based tools ?

Probably getting a perfmon tree that works. I guess Stephane
can help (cc'ed).  Or just deal with imprecise events for now.

-Andi
-- 
ak@linux.intel.com
