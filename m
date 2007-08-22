Return-Path: <linux-kernel-owner+w=401wt.eu-S933378AbXHVRDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378AbXHVRDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXHVRDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:03:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:15706 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052AbXHVRDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=rf0N4BLhyeyUBVFkx2Dn0lDoDeeVsLQhsHs7Doc7GL09f3YgLbyqSCjLar0PIcs0rTbM2UojiXWVfrrC92by/pUN5+XfcquMfFbk6Mb6lKkJnnaqnxX/vZwPjHzCPwZg0sMMW/Aq3MKUbRbi5MyYudlIHxtGVYwF/DRsRIjIQOo=
Message-ID: <46CC6BFE.3020400@googlemail.com>
Date: Wed, 22 Aug 2007 19:01:50 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.23-rc3-mm1
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	<46CC3B27.10604@googlemail.com> <20070822090953.78a3d90c.akpm@linux-foundation.org>
In-Reply-To: <20070822090953.78a3d90c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 22 Aug 2007 15:33:27 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> ...
>>
>>  CC      arch/i386/boot/cpu.o
>>   CC      arch/i386/boot/cpucheck.o
>> WARNING: "div64_64" [net/netfilter/xt_connbytes.ko] has no CRC!
>>   CC      arch/i386/boot/edd.o
>>   AS      arch/i386/boot/header.o
>>   CC      arch/i386/boot/main.o
> 
> Yeah, I get that too.  I was hoping that someone who had a vague clue
> about what's causing it might fix it also.

Hmm.. I don't know ( added netdev to Cc ) I got one more :

...

WARNING: "div64_64" [net/ipv4/tcp_cubic.ko] has no CRC!

...

Btw when modprobing these the kernel gets tainted

...

[ 5498.536055] nf_conntrack version 0.5.0 (10240 buckets, 40960 max)
[ 5498.554844] xt_connbytes: no version for "div64_64" found: kernel tainted.

...


> 
>> ...
>>
>> config : http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/config
>> build-log: http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/build-log
>>
