Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbYKNPty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbYKNPty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 10:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYKNPtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 10:49:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37903 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYKNPto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 10:49:44 -0500
Date: Fri, 14 Nov 2008 16:59:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
       oprofile-list@lists.sf.net, Ingo Molnar <mingo@elte.hu>,
       Jiri Kosina <jkosina@suse.cz>, Jiri Benc <jbenc@suse.cz>,
       Vilem Marsik <vmarsik@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: Oprofile : need to adjust PC by 16 bytes
Message-ID: <20081114155904.GJ3810@one.firstfloor.org>
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz> <20081113212446.GA5694@elte.hu> <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz> <20081113213744.GA8429@elte.hu> <491CA0DC.8070405@cosmosbay.com> <491D987F.1000301@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491D987F.1000301@cosmosbay.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 04:25:51PM +0100, Eric Dumazet wrote:
> Very strange results on my Intel E5450 CPU
> 
> I found that I have to bias regs->ip by 16 bytes in order to have
> correct profiling.

Can you expand a bit how you determined if the profile is right or wrong?

-Andi
