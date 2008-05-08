Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbYEHXLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbYEHXLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYEHXKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:10:52 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:49787 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYEHXKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:10:51 -0400
Message-ID: <482388C9.2080909@keyaccess.nl>
Date: Fri, 09 May 2008 01:12:09 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: GIT bisection range errors
References: <48237CA0.4080001@keyaccess.nl> <alpine.LFD.1.10.0805081557580.2940@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805081557580.2940@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-05-08 01:00, Linus Torvalds wrote:

> On Fri, 9 May 2008, Rene Herman wrote:

>> I'm in a git bisect and am experiencing strangeness. I did a
>>
>> $ git checkout -b rc v2.6.26-rc1
>> $ git bisect start
>> $ git bisect bad
>> $ git bisect good v2.6.25
>>
>> Yet, during this I'm finding myself at 2.6.25-rc6 and 2.6.25-rc8
>> as the last two results (both good...).
> 
> This is very normal.
> 
> Why?
> 
> Because a lot (in fact, *most*) of the code that was merged after v2.6.25 
> was released was actually *written* and committed long before v2.6.25.
> 
> It just got merged into my tree much later.
> 
> So what happens? The bisection run starts walking into all that history, 
> and that history is *not* based on the released v2.6.25 at all, it's based 
> on much earlier kernels (eg the -rc kernels).
> 
> So what you see is perfectly normal and expected. It's only unexpected if 
> you think of history as a linear thing, but it isn't - it's full of 
> merging of code that was branched off from (much) earlier code points.

Ah. Yes, that needs a bit of thought re-warping, but I guess that makes sense.

Thanks much, was afraid I needed to rebuild my local tree.

Rene.
