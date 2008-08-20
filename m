Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbYHTXDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbYHTXDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 19:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYHTXD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 19:03:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:59456 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYHTXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 19:03:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=WzwrYvQss7Y1Zl22xs9paqrr3T2Wh+GktG5NGRkP4LZedZNhZDvCOLJuiQAp9KaEQo
         PWqdYIhmWSgWWCps4O2lS+UHEcZNZwjQB7x8N/AOgeJBF8cVs89Abmw+wqp5C/VCc3nB
         OidQlSF3LEPEVH1qkUv39oqtSzJDxO9dNQIZ8=
References: <200808210045.42693.rjw@sisk.pl> <alpine.LFD.1.10.0808201548300.3487@nehalem.linux-foundation.org> <200808210058.06515.rjw@sisk.pl>
Message-Id: <12048FAE-DA5F-432A-9030-7BD10F95050C@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200808210058.06515.rjw@sisk.pl>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5C1)
Mime-Version: 1.0 (iPhone Mail 5C1)
Subject: Re: [OT] 'git pull' from Linus' tree doesn't work for me any more
Date: Wed, 20 Aug 2008 16:03:21 -0700
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pulled this morning  PDT,
Without any issues.

justin P. Mattock



On Aug 20, 2008, at 3:58 PM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday, 21 of August 2008, Linus Torvalds wrote:
>>
>> On Thu, 21 Aug 2008, Rafael J. Wysocki wrote:
>>>
>>> Does anybody else see something like this after the latest push  
>>> from Linus:
>>>
>>> ~/devel/linux-2.6> git pull
>>> fatal: The remote end hung up unexpectedly
>>> Cannot get the repository state from git://git.kernel.org/pub/scm/ 
>>> linux/kernel/git/torvalds/linux-2.6.git
>>>
>>> I see this on two different machines.
>>
>> It might easily be just a temporary glitch in the matrix.
>>
>> It happens sometimes because the kernel.org machines use rsync to
>> synchronize with each other, and since it's not really a git-aware
>> protocol, rsync might copy the branch files _before_ it copies the  
>> object
>> files.
>>
>> It starts working after a few minutes when the rsync has completed.
>
> Well, it hasn't been working for a couple of hours now ...
>
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
