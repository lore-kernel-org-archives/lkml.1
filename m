Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbZA0XEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbZA0XEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbZA0XE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:04:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:60814 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbZA0XE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:04:28 -0500
Message-ID: <497F92F8.5040806@kernel.org>
Date: Wed, 28 Jan 2009 08:04:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20090127073055.GA30360@havoc.gtf.org> <alpine.LFD.2.00.0901270748290.3123@localhost.localdomain> <497F545B.6000104@garzik.org> <alpine.LFD.2.00.0901271100320.3123@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901271100320.3123@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 27 Jan 2009 23:04:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus, Jeff.

Linus Torvalds wrote:
> 
> On Tue, 27 Jan 2009, Jeff Garzik wrote:
>> I also habitually _avoid_ "git commit -a", so I am surprised that I actually
>> made this mistake.  I am 100% certain that I issued neither "git rm" nor "git
>> update-index" commands on that file.
>>
>> Granted, I should have been more careful, but I am also surprised this
>> happened at all.
> 
> Well, it's attributed to Tejun, and he probably sent you a "git diff". The 
> delete part of such a diff is pretty small, so you both probably missed 
> it at the top of the diff:
> 
> 	diff --git a/arch/arm/mach-integrator/clock.h b/arch/arm/mach-integrator/clock.h
> 	deleted file mode 100644
> 	index e69de29..0000000
> 
> and then you used "git am -s" or something to apply it and delete that 
> file.
> 
> No "git commit -a" necessary - just a simple "git diff" after having done 
> a "make distclean" and then sending the result off by email without 
> looking any closer..

Yes, that patch was generated with "git diff" and distclean was done
cuz I just began to use separate output directories for build.  I've
restored the empty file for several times for other patches but it
slipped this time.  My apologies.  I'll be more careful.

Thanks.

-- 
tejun
