Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbXHJCfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbXHJCfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbXHJCfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:35:03 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46125 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbXHJCfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:35:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: YOSHIFUJI Hideaki / =?euc-jp?B?tcjGo7HRzMA=?= 
	<yoshfuji@linux-ipv6.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       adobriyan@sw.ru
Subject: Re: [PATCH 3/3] sysctl: Error on bad sysctl tables
References: <m1tzr8a3ms.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1wa3kf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com>
	<20070810.110144.117508471.yoshfuji@linux-ipv6.org>
Date: Thu, 09 Aug 2007 20:15:37 -0600
In-Reply-To: <20070810.110144.117508471.yoshfuji@linux-ipv6.org> (YOSHIFUJI
	Hideaki's message of "Fri, 10 Aug 2007 11:01:44 +0900 (JST)")
Message-ID: <m1wsw46som.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=euc-jp
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YOSHIFUJI Hideaki / µ»∆£±—Ã¿ <yoshfuji@linux-ipv6.org> writes:

> Hello.
>
> In article <m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com> (at Thu, 09 Aug 2007
> 14:09:29 -0600), ebiederm@xmission.com (Eric W. Biederman) says:
>
>> After going through the kernels sysctl tables several times it has
>> become clear that code review and testing is just not effective in
>> prevent problematic sysctl tables from being used in the stable
>> kernel.  I certainly can't seem to fix the problems as fast as
>> they are introduced.
> :
>> The biggest part of the code is the table of valid binary sysctl
>> entries, but since we have frozen our set of binary sysctls this table
>> should not need to change, and it makes it much easier to detect
>> when someone unintentionally adds a new binary sysctl value.
>
> I don't think everyone needs to have this code, so
> it is better to make it configurable via
> CONFIG_SYSCTL_DEBUG or something..., ...no?

I wouldn't reject such a patch.  We are a ways out from the next
stable kernel merge window and I'd love to see what else falls out so
I'd like to have it on by default for a bit.

Eric
