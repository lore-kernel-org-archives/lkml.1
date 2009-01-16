Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbZAPQeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbZAPQeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbZAPQeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:34:04 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:56624 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZAPQeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:34:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DuYJ3SYH7H4dw7dytoTwlYyUso0xtjfWWHlALrVNtdee97L3eqsy7JtKBY3I9Wne5g
         kSWYHWb5VyPf489DX673/ZIfJ1UT0+GbR46JDGs6I0Qx6dBRduaEMlJZXq7Mz+FvJL3k
         p6B0Ma605Tx+eUKMFKXz58soC5k8w1WrvH2VQ=
MIME-Version: 1.0
In-Reply-To: <20090115185009.GE6896@shadowen.org>
References: <3f9a31f40901120903yc6a85e0w4c2fe57352f1f482@mail.gmail.com>
	 <20090115185009.GE6896@shadowen.org>
Date: Fri, 16 Jan 2009 22:04:00 +0530
Message-ID: <3f9a31f40901160834j38ea620dl31400411e8ef50e5@mail.gmail.com>
Subject: Re: scripts/checkpatch.pl: WARNING: patch prefix 'arch' exists, 
	appears to be a -p0 patch
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: davej@redhat.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 12:20 AM, Andy Whitcroft <apw@canonical.com> wrote:
> On Mon, Jan 12, 2009 at 10:33:40PM +0530, Jaswinder Singh Rajput wrote:
>> Hello Andy,
>>
>> How to get rid of this warning:
>>
>>  #./scripts/checkpatch.pl --file arch/x86/kernel/module_32.c
>> WARNING: patch prefix 'arch' exists, appears to be a -p0 patch
>>
>> total: 0 errors, 1 warnings, 152 lines checked
>>
>> arch/x86/kernel/module_32.c has style problems, please review.  If any
>> of these errors
>> are false positives report them to the maintainer, see
>> CHECKPATCH in MAINTAINERS.
>
> That looks wrong to me.  Will have a look at it.
>
> Ahh yes, thats just wrong.  Should be fixed in the tip of my tree, and
> will be in the next block of updates.  You can check against the version
> at:
>
>  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing
>

Fixed, thanks :-)

--
JSR
