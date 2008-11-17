Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbYKQPPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbYKQPPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYKQPO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:14:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41241 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYKQPO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:14:57 -0500
Date: Mon, 17 Nov 2008 16:24:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
       Jiri Benc <jbenc@suse.cz>, Vilem Marsik <vmarsik@suse.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Oprofile : need to adjust PC by 16 bytes
Message-ID: <20081117152434.GM6703@one.firstfloor.org>
References: <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz> <20081113213744.GA8429@elte.hu> <491CA0DC.8070405@cosmosbay.com> <491D987F.1000301@cosmosbay.com> <18717.44751.459961.277998@harpo.it.uu.se> <491DB391.2040701@cosmosbay.com> <20081114175056.GK3810@one.firstfloor.org> <491EF942.1090709@cosmosbay.com> <20081115183627.GL3810@one.firstfloor.org> <7c86c4470811170702y127c9249m9b86b65a38a3e05c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811170702y127c9249m9b86b65a38a3e05c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 04:02:19PM +0100, stephane eranian wrote:

Thanks for explaining it better than I could.

Just a minor correction.

> But it can be very large when overflow happens
> during a kernel critical section
> where interrupts are off.

Actually oprofile uses the NMI to avoid that particular problem.
It still has limits, e.g. no profiling of SMM sections.

> There is nothing SW can do about all of this.

Yes profiling on a out of order machine is hard.

> Furthermore, PEBS can record samples while
> in kernel critical sections. 

Again with oprofile that works too without PEBS.

-Andi
