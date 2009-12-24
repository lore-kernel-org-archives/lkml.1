Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZLXMW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZLXMW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbZLXMW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:22:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:37112 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbZLXMWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:22:55 -0500
Message-ID: <4B335DE6.9030102@kernel.org>
Date: Thu, 24 Dec 2009 21:26:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, x86@kernel.org
Subject: Re: 2.6.32 regression: unable to handle kernel paging request
References: <4B269765.1070703@klingt.org> <4B2A2A7D.1050506@klingt.org> <4B2A93F2.3070407@klingt.org> <4B2AFBB1.3040609@kernel.org> <4B2B4838.6080509@klingt.org> <4B2F20E0.30804@kernel.org> <4B2F40C0.5020407@klingt.org> <4B33592B.6000107@kernel.org> <4B335964.6040202@klingt.org>
In-Reply-To: <4B335964.6040202@klingt.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/24/2009 09:07 PM, Tim Blechmann wrote:
>>> as i said before, the configuration is not really uncommon ... the
>>> readelf output is attached.
>>
>> Hmmm.... I think it's more convoluted than I originally thought.  I
>> was expecting a missing section but in the broken case the linker has
>> assigned addresses to sections even though it was a relocatable link.
>> That's just strange.
>>
>> Can you please post the output of "ld --version"?  Also, what distro
>> are you on?
> 
> i am not at that specific machine, but the distribution is the same as
> on my laptop, ubuntu 9.10, x86-64. i don't have any issues, running
> 2.6.32.2 on my laptop, though ...
> 
> GNU ld (GNU Binutils for Ubuntu) 2.20

Sections aren't supposed to have addresses assigned in relocatable
output and it of course breaks things.  I'll try newer version of
binutils but at this point it looks like a linker bug.  Can you please
report it to ubuntu too?

Thanks.

-- 
tejun
