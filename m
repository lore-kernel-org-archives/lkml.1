Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZDFKJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZDFKJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 06:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZDFKIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 06:08:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:36079 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbZDFKIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 06:08:50 -0400
Message-ID: <49D9D4D8.2020608@kernel.org>
Date: Mon, 06 Apr 2009 03:09:28 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <ckpL0-3TE-3@gated-at.bofh.it> <ckpL0-3TE-5@gated-at.bofh.it> <ckpL0-3TE-7@gated-at.bofh.it> <ckpL0-3TE-9@gated-at.bofh.it> <ckpL0-3TE-11@gated-at.bofh.it> <ckpL0-3TE-1@gated-at.bofh.it> <cllvN-2Gf-1@gated-at.bofh.it> <49D0D788.6070405@gmail.com> <49D419E8.2080603@kernel.org> <49D4591B.3070807@gmail.com> <49D46096.1040701@kernel.org> <49D49B8A.7070408@gmail.com> <49D4C886.1010101@gmail.com> <49D6E7FA.3000306@kernel.org> <49D98C9E.2000507@gmail.com>
In-Reply-To: <49D98C9E.2000507@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 06 Apr 2009 10:08:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Niel Lambrechts wrote:
> On 04/04/2009 06:54 AM, Tejun Heo wrote:
>> Hello, Neil.
>>
>> Niel Lambrechts wrote:
>>   
>>>> Thanks for your help, I've done at least 5 hibernate cycles without the
>>>> problem recurring, I'll keep at it for a while... :)
>>>>       
>> Hmmm..
>>   
> Hi Tejun,
> 
> I have tested your patch some more over the weekend as well as on
> 2.6.29.1, and suspend-to-disk and ram still works without a glitch for
> me apart from the extra debugging being active.
> 
> Will the fix naturally make its way into the mainline kernel, or is
> there any extra debugging/testing I can help with?

Well, the problem is the debug patch doesn't actually do anything
other than printing out messages.  It could be that the problem is
timing dependent (which is likely anyway).  You still can reporduce
the problem with the patch, right?

Thanks.

-- 
tejun
