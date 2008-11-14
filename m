Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYKNRlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYKNRlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYKNRld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:41:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53606 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYKNRld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:41:33 -0500
Date: Fri, 14 Nov 2008 18:50:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
       Jiri Benc <jbenc@suse.cz>, Vilem Marsik <vmarsik@suse.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Oprofile : need to adjust PC by 16 bytes
Message-ID: <20081114175056.GK3810@one.firstfloor.org>
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz> <20081113212446.GA5694@elte.hu> <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz> <20081113213744.GA8429@elte.hu> <491CA0DC.8070405@cosmosbay.com> <491D987F.1000301@cosmosbay.com> <18717.44751.459961.277998@harpo.it.uu.se> <491DB391.2040701@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491DB391.2040701@cosmosbay.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >And no, blindly subtracting 16 from IP is not a fix.
> 
> Who mentioned a fix ? I am only giving more fuel to Intel guys so they
> hopefully can give us a working oprofile.

You would need to implement PEBS support to avoid that problem. But it's a big
task. perfmon2 implements it already.

-Andi
