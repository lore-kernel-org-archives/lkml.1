Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYHLROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYHLROU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 13:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYHLROM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 13:14:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47581 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYHLROM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 13:14:12 -0400
Date: Tue, 12 Aug 2008 13:14:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Roland Dreier <rdreier@cisco.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, rolandd@cisco.com,
       sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org
Subject: Re: [PATCH] infiniband: change flags from int to long
In-Reply-To: <aday732w8d6.fsf@cisco.com>
Message-ID: <alpine.DEB.1.10.0808121310550.30444@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808121030160.18695@gandalf.stny.rr.com> <aday732w8d6.fsf@cisco.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 12 Aug 2008, Roland Dreier wrote:

>  > It is a bug to have irq saved flags as an int and not long since
>  > some archs may use more that 32 bits in flags.
> 
> Isn't this already upstream for a while as 52fd8ca6?

This is the problem with having multiple git repos lying around. You never 
know which one is updated. I should have done a git pull on the git repo I 
examined.

Last commit on the repo I looked at:

commit 94ad374a0751f40d25e22e036c37f7263569d24c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 30 14:45:12 2008 -0700


And the commit you stated:

commit 52fd8ca6ad4124c15952ded35cfcf6adbd7ae8d4
Author: Vegard Nossum <vegard.nossum@gmail.com>
Date:   Wed Jul 30 09:29:06 2008 -0700


Which Linus pulled in on:

commit 273b2578392bbf6e5c47a8a3d1ee461ce6fc7182
Merge: 8e43e12... 06a91a0...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Aug 7 18:14:07 2008 -0700


Sorry for the noise :-/

-- Steve

