Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZKTO52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZKTO52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZKTO51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:57:27 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:32706 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbZKTO50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 09:57:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=vxmmqnMAlzLsZ99IWhxQoTCfj3XF7xN14LnJ5SfUCYl9x7jOhy+htxhIUF36mtX4o5
         Mkhmc1U2Jm4UxIKTDLgWfsM/M3fYCTabmR0V750mRccyKS3yMaJaoMeUnaLFy5EDJ+KX
         05jlm0tO1q8RwpmlErlijgPQqQmh1bzDdnHcU=
MIME-Version: 1.0
In-Reply-To: <6dd519ae0910080228n4eb9853eg38bfbb6584729371@mail.gmail.com>
References: <6dd519ae0910071634q329239f2n360c8a54fcb81a26@mail.gmail.com>
	 <6dd519ae0910071710q6d4acealb749966a86fb860b@mail.gmail.com>
	 <6dd519ae0910071805y6000f563y422c42f43bc5e6a2@mail.gmail.com>
	 <Pine.LNX.4.64.0910080958520.25169@sister.anvils>
	 <6dd519ae0910080228n4eb9853eg38bfbb6584729371@mail.gmail.com>
Date: Fri, 20 Nov 2009 17:57:27 +0300
Message-ID: <6dd519ae0911200657l752437f5i7c97669328a2b381@mail.gmail.com>
Subject: Re: BUG: bad page state in process (In version 2.6.31.2)
From: Brian Marete <bgmarete@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since upgrading to 2.6.31.5 (and now running 2.6.31.6), I have not
been able to replicate this bug, whether with the proprietary modules
loaded or not.

Thanks!

On Thu, Oct 8, 2009 at 12:28 PM, Brian Marete <bgmarete@gmail.com> wrote:
> Ok. Will do without having the nvidia module loaded and report on the
> results. Also, I run a full pass of memtest86 and no problems were
> discovered.
>
> Thanks!
>
> On 10/8/09, Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
>> On Thu, 8 Oct 2009, Brian Marete wrote:
>>> On Thu, Oct 8, 2009 at 3:10 AM, Brian Marete <bgmarete@gmail.com> wrote:
>>> > On Thu, Oct 8, 2009 at 2:34 AM, Brian Marete <bgmarete@gmail.com> wrote:
>>> >>
>>> >> Just found the BUG back-trace pasted below in my kernel logs.
>>>
>>> Rebooted the machine and the same BUG manifests. See the trace below:
>>>
>>> (Also, run memtest86 just in case I have bad memory.)
>>>
>>> [  726.890990] BUG: Bad page state in process tracker-indexer  pfn:77541
>>> [  726.890997] page:c47eb820 flags:80000000 count:0 mapcount:0
>>> mapping:00000001 index:0
>>
>>                  ^ for some reason that page->mapping got a 1 in it.
>>
>>> [  726.891002] Pid: 9758, comm: tracker-indexer Tainted: P
>>> 2.6.31.2 #1
>>
>>                    but you're using a Proprietary module   ^
>>
>> It's great that you can reproduce this case easily, but please try
>> without Proprietary modules loaded - they're often the origin, and
>> we're unable to debug them.
>>
>> Thanks,
>> Hugh
>>
>
>
> --
> B. Gitonga Marete
> Tel: +254-722-151-590
>



-- 
B. Gitonga Marete
Tel: +254-722-151-590
