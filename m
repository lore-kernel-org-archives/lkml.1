Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbZBJBhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbZBJBhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 20:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZBJBhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 20:37:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:55962 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZBJBhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 20:37:31 -0500
Message-ID: <4990DA3B.7060109@kernel.org>
Date: Tue, 10 Feb 2009 10:36:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, hpa@zytor.com, jeremy@goop.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCHSET x86/master] add stack protector support for x86_32
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <73c1f2160902090609qeabc926nc5579f87c1ca5207@mail.gmail.com> <20090209141525.GA24897@elte.hu>
In-Reply-To: <20090209141525.GA24897@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Feb 2009 01:37:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> I had a patch a while back that would convert those function to take a
>> pointer to pt_regs instead of assuming that the struct was passed by
>> value. [...]
> 
> Yes, that's the right solution. Getting a new call convention recognized
> is a 3 years timeframe project for a whole team of hackers. Adding a
> pointer is a 30 minutes project for one good kernel hacker ;)
> 
>> [...]  I'll take a stab at reworking it on top of this series.
> 
> Cool!

We do add some overhead that way and Linus was against it several
years ago, so the addition of asmlinkage_protect() macros.  Given that
the calling convention thing never happened through all the years and
modern machines probably wouldn't care much one way or the other, it
could just be about time to convert to pointer passing.

Thanks.

-- 
tejun
