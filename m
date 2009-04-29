Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbZD2Fhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbZD2Fhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZD2FhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:37:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35917
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbZD2FhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:37:15 -0400
Date: Tue, 28 Apr 2009 22:37:08 -0700 (PDT)
Message-Id: <20090428.223708.168741998.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: shemminger@vyatta.com, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       dada1@cosmosbay.com, zbr@ioremap.net, peterz@infradead.org,
       jarkao2@gmail.com, paulus@samba.org, paulmck@linux.vnet.ibm.com,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: revised locking for x_tables
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0904280954500.22156@localhost.localdomain>
References: <20090428092411.5331c4a1@nehalam>
	<alpine.LFD.2.00.0904280931360.22156@localhost.localdomain>
	<alpine.LFD.2.00.0904280954500.22156@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Apr 2009 09:55:32 -0700 (PDT)

> On Tue, 28 Apr 2009, Linus Torvalds wrote:
>>
>> Ack. 
>> 
>> It could do with the update from Eric about how non-current CPU writelocks 
>> only require preemp-disable around get_counters() (and then the 
>> local_bh_disable() only around the current-CPU case).
> 
> Btw, regardless, that's an incremental improvement, and does not negate 
> the "Ack" part.

I've applied this, thanks everyone!
