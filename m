Return-Path: <linux-kernel-owner+w=401wt.eu-S1762941AbYDQI5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762941AbYDQI5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762655AbYDQI5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:57:40 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53046
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762613AbYDQI5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:57:39 -0400
Message-ID: <48071101.2030003@qumranet.com>
Date: Thu, 17 Apr 2008 11:57:37 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
References: <20080416202338.GA6007@elte.hu>	<20080417002552.5742ad65.akpm@linux-foundation.org> <20080417011401.ea3e70f0.akpm@linux-foundation.org>
In-Reply-To: <20080417011401.ea3e70f0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 17 Apr 2008 00:25:52 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>
>   
>> A quick grep indicates that only 644 of
>> these 884 patches are in -mm.  And a lot of them only turned up a week or
>> two ago.
>>     
>
> I did a test merge.
>
> - About 13 patch rejects agaisnt git-kvm
>
>
>   
[...]

> So not as bad as it might have been.  kvm and page-flags are the major
> problems.  Of course, none of this has been compiled and this proposed code
> combination has never been tested by anyone at runtime.
>
>   

Once git-x86 is pulled, I will rebase kvm.git against -linus, retest, 
and submit (have to wait for s390 and ia64 anyway).

-- 
error compiling committee.c: too many arguments to function

