Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZHQQfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZHQQfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 12:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757161AbZHQQfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 12:35:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58475 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073AbZHQQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 12:35:33 -0400
Message-ID: <4A8986BB.80409@cs.helsinki.fi>
Date: Mon, 17 Aug 2009 19:35:07 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] proc: drop write permission on 'timer_list' and 'slabinfo'
References: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>  <20090817094822.GA17838@elte.hu> <1250502847.5038.16.camel@penberg-laptop> <alpine.DEB.1.10.0908171228300.16267@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0908171228300.16267@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Lameter wrote:
> On Mon, 17 Aug 2009, Pekka Enberg wrote:
> 
>>> I have applied the timer_list bits to the timer tree. The SLUB/SLAB
>>> bits should go into the SLAB tree i guess.
>> Yeah, I'll grab the slab parts to slab.git if I don't see a separate
>> patch in my inbox when I get home. Thanks!
> 
> slab needs the write permissions for tuning!

Oh, crap, you're right, I had forgotten about that. It's probably best 
to keep slub permissions as-is, no?

			Pekka
