Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZFEE2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZFEE2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZFEE2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:28:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:52407 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZFEE2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:28:24 -0400
Message-ID: <4A289E3A.30000@kernel.org>
Date: Fri, 05 Jun 2009 13:25:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Miller <davem@davemloft.net>, JBeulich@novell.com,
       andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, ink@jurassic.park.msu.ru,
       rth@twiddle.net, linux@arm.linux.org.uk, hskinnemoen@atmel.com,
       cooloney@kernel.org, starvik@axis.com, jesper.nilsson@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
       takata@linux-m32r.org, geert@linux-m68k.org, monstr@monstr.eu,
       ralf@linux-mips.org, kyle@mcmartin.ca, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, chris@zankel.net, rusty@rustcorp.com.au,
       jens.axboe@oracle.com, davej@redhat.com, jeremy@xensource.com,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/7] percpu: clean up percpu variable definitions
References: <1243846708-805-1-git-send-email-tj@kernel.org>	 <1243846708-805-4-git-send-email-tj@kernel.org>	 <20090601.024006.98975069.davem@davemloft.net>	 <4A23BD20.5030500@kernel.org> <1243919336.5308.32.camel@pasglop>
In-Reply-To: <1243919336.5308.32.camel@pasglop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 04:25:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Mon, 2009-06-01 at 20:36 +0900, Tejun Heo wrote:
>>> Whether the volatile is actually needed or not, it's bad to have this
>>> kind of potential behavior changing nugget hidden in this seemingly
>>> inocuous change.  Especially if you're the poor soul who ends up
>>> having to debug it :-/
>> You're right.  Aieee... how do I feed volatile to the DEFINE macro.
>> I'll think of something.
> 
> Or better, work with the cris maintainer to figure out whether it's
> needed (it probably isn't) and have a pre-requisite patch that removes
> it before your series :-)

Yeap, that's worth giving a shot.

Mikael Starvik, can you please enlighten us why volatile is necessary
there?

Thanks.

-- 
tejun
