Return-Path: <linux-kernel-owner+w=401wt.eu-S1761126AbZCYNXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761126AbZCYNXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbZCYNX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:23:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:52394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbZCYNX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:23:27 -0400
Message-ID: <49CA2FBF.9000207@kernel.org>
Date: Wed, 25 Mar 2009 22:21:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <1236671631-9305-1-git-send-email-tj@kernel.org>	<20090316190132.7965a49a@skybase>	<49C300D8.5080204@kernel.org>	<49C8FAC4.6060508@kernel.org>	<20090325122738.42d105b7@skybase>	<49CA1AC3.9080908@kernel.org>	<20090325122241.GE11571@elte.hu>	<49CA2345.70204@kernel.org> <20090325141330.2717dc97@skybase>
In-Reply-To: <20090325141330.2717dc97@skybase>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 13:21:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
>> Martin's original patch should do the trick although it would be
>> slower for static symbols.  I'll merge it and post the tree.
> 
> No, my original patch doesn't work. It will break modules that use
> static per-cpu variables.

Oops.  Even with the default offset adding macros?  Heh... I think it
would be best to wait for your fix then.

Thanks.

-- 
tejun
