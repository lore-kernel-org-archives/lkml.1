Return-Path: <linux-kernel-owner+w=401wt.eu-S934755AbXHJRej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934755AbXHJRej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbXHJRe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:34:28 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36471 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbXHJRe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:34:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>, coreteam@netfilter.org
Subject: Re: 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC8F71.3070006@googlemail.com> <46BC944F.9020801@googlemail.com>
Date: Fri, 10 Aug 2007 11:33:41 -0600
In-Reply-To: <46BC944F.9020801@googlemail.com> (Gabriel C.'s message of "Fri,
	10 Aug 2007 18:37:35 +0200")
Message-ID: <m1fy2rxpje.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C <nix.or.die@googlemail.com> writes:

> Michal Piotrowski wrote:
>> Andrew Morton pisze:
>>>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm2/
>>>
>> 
>> Yet another sysctl table check failed
>> 
>> [   88.949055] Netfilter messages via NETLINK v0.30.
>> [   89.485399] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
>> [ 89.491892] sysctl table check failed:
> /net/netfilter/nf_conntrack_generic_timeout .3.19.13 Missing strategy
>> [   89.558178] xt_state: Unknown symbol nf_conntrack_untracked
>> [   89.563942] xt_state: Unknown symbol nf_ct_l3proto_module_put
>> [   89.569870] xt_state: Unknown symbol nf_ct_l3proto_try_module_get
>> [   90.852319] NET: Registered protocol family 17
>>
>
> And maybe this ?

Could be.

sysctl table check failure looks legitimate.
At a quick skim I can't tell for certain if failure to register the
sysctl table will keep the module from loading but it might.

It looks like another canidate on the pile of kill the broken
binary sysctl.

Eric
