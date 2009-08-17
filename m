Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbZHQQmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbZHQQmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 12:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbZHQQl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 12:41:59 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:34206 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755793AbZHQQl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 12:41:59 -0400
Date: Mon, 17 Aug 2009 12:41:54 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Ingo Molnar <mingo@elte.hu>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] proc: drop write permission on 'timer_list' and
 'slabinfo'
In-Reply-To: <4A8986BB.80409@cs.helsinki.fi>
Message-ID: <alpine.DEB.1.10.0908171240370.16267@gentwo.org>
References: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>  <20090817094822.GA17838@elte.hu> <1250502847.5038.16.camel@penberg-laptop> <alpine.DEB.1.10.0908171228300.16267@gentwo.org> <4A8986BB.80409@cs.helsinki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009, Pekka Enberg wrote:

> > slab needs the write permissions for tuning!
>
> Oh, crap, you're right, I had forgotten about that. It's probably best to keep
> slub permissions as-is, no?

slub perms can be changed. The patch is okay for that. But there is no
write method in slub. Effectively it makes no difference. Just the
display is nicer in /proc.


