Return-Path: <linux-kernel-owner+w=401wt.eu-S934454AbZDBB6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454AbZDBB6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbZDBB6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:58:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:41405 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060AbZDBB6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:58:07 -0400
Message-ID: <49D41B79.60708@kernel.org>
Date: Thu, 02 Apr 2009 10:57:13 +0900
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
References: <1236671631-9305-1-git-send-email-tj@kernel.org>	<20090316190132.7965a49a@skybase>	<49C300D8.5080204@kernel.org>	<49C8FAC4.6060508@kernel.org>	<20090325122738.42d105b7@skybase>	<49CA1AC3.9080908@kernel.org>	<20090325122241.GE11571@elte.hu>	<49CA2345.70204@kernel.org>	<20090325141330.2717dc97@skybase>	<49CA2FBF.9000207@kernel.org>	<20090325142525.2d31c522@skybase>	<49CA32F6.2030408@kernel.org>	<20090331185431.72ff1707@skybase>	<49D2B04D.4070604@kernel.org>	<20090401101054.0a4b187d@skybase>	<49D3231D.2040403@kernel.org>	<20090401103257.12c2517e@skybase>	<49D32B96.3060102@kernel.org> <20090401130731.785714c5@skybase>
In-Reply-To: <20090401130731.785714c5@skybase>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 01:56:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Martin Schwidefsky wrote:
>> Maybe we can build indirection pointer manually by twiddling with
>> DEFINE_PER_CPU() in such a way that it doesn't have to distinguish
>> symbols and variables?
> 
> Hmm, a provocative idea: can we ban the use of static per-cpu variables
> for modules in common code? There are not many common code modules
> doing this, with a visibility hack I found the following relevant
> locations:
>
> ....
> 
> That would "fix" the problem as well..

Eh... I don't know.  I'd really like remove such API limitations as
most of the necessary pieces are already there anyway, so I'd much
prefer the re-mapping thing if it can be made to work.

Thanks.

-- 
tejun
