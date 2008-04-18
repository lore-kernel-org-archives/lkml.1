Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYDROto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYDROto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYDROth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:49:37 -0400
Received: from tornado.reub.net ([59.167.255.179]:35443 "EHLO tornado.reub.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbYDROtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:49:36 -0400
X-DKIM: Sendmail DKIM Filter v2.5.2 tornado.reub.net 8C26E129AEB
Message-ID: <4808B4EF.8030901@reub.net>
Date: Sat, 19 Apr 2008 00:49:19 +1000
From: Reuben Farrelly <reuben-linuxkernel@reub.net>
User-Agent: Thunderbird 2.0.0.15pre (Windows/20080417)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: StackProtector Oopses - Re: 2.6.25-mm1
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <48089BDE.6040100@reub.net> <20080418133645.GF31797@elte.hu>
In-Reply-To: <20080418133645.GF31797@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/04/2008 11:36 PM, Ingo Molnar wrote:
> * Reuben Farrelly <reuben-linuxkernel@reub.net> wrote:
> 
>> is enough to prevent my system booting, viz:
> 
> hm, does it boot up fine with the attached patch and stackprotector 
> enabled? It appears that your system got to the self-test so 
> stackprotector is working mostly - it's just that the self-test went 
> wrong.

It boots up fine with that patch below and:

tornado boot # grep STACKPROTECT /boot/config-2.6.25-mm1-wip
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y

In fact I'm running with it applied right now and it all seems good so far, so I 
guess that's confirmation that it is just the test itself which is problematic?

Reuben
