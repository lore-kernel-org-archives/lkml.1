Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbXKDHht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbXKDHht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 02:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXKDHhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 02:37:42 -0500
Received: from il.qumranet.com ([82.166.9.18]:43696 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbXKDHhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 02:37:41 -0500
Message-ID: <472D76C4.2080603@qumranet.com>
Date: Sun, 04 Nov 2007 09:37:40 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Bart Trojanowski <bart@jukie.net>
CC: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [BUG] 2.6.23.1 host freezes when running kvm
References: <20071019202019.GW3962@jukie.net> <20071020000240.GX3962@jukie.net>	<20071020154445.GA5254@jukie.net> <471B366B.7040706@qumranet.com>	<20071022132820.GA3962@jukie.net> <471CA88B.7000706@qumranet.com>	<20071023135410.GF3962@jukie.net> <471E033E.20701@qumranet.com> <20071102171933.GE32719@jukie.net>
In-Reply-To: <20071102171933.GE32719@jukie.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Trojanowski wrote:
> * Avi Kivity <avi@qumranet.com> [071023 10:21]:
>   
>> Thanks, that will be most helpful.  If userspace won't compile against
>> some intermediate version, let me know the commit hash and I'll add a fixup.
>>     
>
> A bisect didn't find anything between 2.6.22 and 2.6.23.  Which made me
> very confused.  I think, I must have used the Debian userland tools...
> which is still bad and I will double check that with 2.6.23.
>   

Yes.  You can use the same tools for all versions from .22 and up.

Another thing to try is whether the lockup reproduces with 'taskset 1'.  
Maybe it is preemption related.

Thanks for the effort.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

