Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbZBEKae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbZBEKae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZBEKaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:30:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:44660 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZBEKaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:30:23 -0500
Message-ID: <498ABFA9.7060203@kernel.org>
Date: Thu, 05 Feb 2009 19:30:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/3] xen: setup percpu data pointers
References: <49876BD3.5070804@goop.org> <498A8738.9050200@gmail.com> <498A8C05.30704@kernel.org> <498A9284.8050805@goop.org>
In-Reply-To: <498A9284.8050805@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Feb 2009 10:29:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Tejun Heo wrote:
>> Tejun Heo wrote:
>>  
>>> Applied 1-3 to #tj-percpu with trivial modification on #2 (will reply
>>> to the message).
>>>     
>>
>> Oh... hpa already merged them into x86/paravirt.  I'll just pull
>> x86/paravirt into core/percpu because the first patch needs to be in
>> core/percpu to keep xen working.
>>
>> hpa, can you please take the other xen patch[1] into x86/paravirt too?
>> So that I can receive it via you?
> 
> Looks like its already there.

Yes, right, which means tj-percpu == x86/paravirt for the time being.
Ingo, please pull from the following to fast forward core/percpu to
x86/paravirt (or you can just do it yourself :-)

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Thanks.

-- 
tejun
