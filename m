Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZFAHcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZFAHcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZFAHbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:31:53 -0400
Received: from ozlabs.org ([203.10.76.45]:43916 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZFAHbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:31:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] cpuhotplug: introduce try_get_online_cpus()
Date: Mon, 1 Jun 2009 17:01:50 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <4A1F9CEE.5090305@cn.fujitsu.com> <20090529133118.1c7b16c2.akpm@linux-foundation.org>
In-Reply-To: <20090529133118.1c7b16c2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906011701.51637.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009 06:01:18 am Andrew Morton wrote:
> I do think that we should look at
> alternative (non-trylocky) ways of fixing them.

Speculating: we could add a "keep_cpu()" (FIXME: improve name) which is kind 
of like get_cpu() only doesn't disable preemption and only stops *this* cpu 
from going down.

Not sure where that gets us, but if someone's going to dig deep into this it 
might help.

Thanks,
Rusty.
