Return-Path: <linux-kernel-owner+w=401wt.eu-S939251AbXHIM1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939251AbXHIM1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760467AbXHIM1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:27:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48399 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756452AbXHIM1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:27:44 -0400
Message-ID: <46BB080F.4040905@sgi.com>
Date: Thu, 09 Aug 2007 14:26:55 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070719)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Carsten Otte <cotte@de.ibm.com>
Subject: Re: [PATCH 4/7] Moved the io struct up to the generic lg.h
References: <20070809003211.373543702@goodmis.org>	<20070809003343.664528532@goodmis.org> <20070809115156.ef5fdc6c.sfr@canb.auug.org.au>
In-Reply-To: <20070809115156.ef5fdc6c.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> On Wed, 08 Aug 2007 20:32:15 -0400 Steven Rostedt <rostedt@goodmis.org>
> wrote:
>> diff --git a/drivers/lguest/i386/lg.h b/drivers/lguest/i386/lg.h
>> index 64f0abe..c5ea14c 100644
>> --- a/drivers/lguest/i386/lg.h
>> +++ b/drivers/lguest/i386/lg.h
>> @@ -20,6 +20,8 @@
>>  #include <linux/err.h>
>>  #include <asm/semaphore.h>
>>  #include "irq_vectors.h"
>> +/* some files include this, some include the parent */
>> +#include "../lg.h"
> 
> Surely everything should just include the parent which allows for easier
> consolidation over time. (as you are doing here)

Whats wrong with introducing an include/asm-<arch>/lg.h and have the
parent do #include <asm/lg.h> ? Seems much cleaner to me.

Cheers,
Jes

