Return-Path: <linux-kernel-owner+w=401wt.eu-S936467AbYBCJMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936467AbYBCJMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 04:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760222AbYBCJMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 04:12:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:24220 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbYBCJL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 04:11:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XHpSHBCQFPBP5ONi4rU7FSTTCI+RxbbOmCNciPRNhB0YxA4V4suzSjvrK2jxibcT7ka/UOhreDUaoNXtvZKha+YmOXHm1gwNM8s1Xj9bPh2q1KT78ZIMF1nM7Srrh7+xjDuga/4f1lcnefKTR3ZPkVK1ppulixICd/kMuBteJGQ=
Message-ID: <47A58550.2000104@gmail.com>
Date: Sun, 03 Feb 2008 10:11:44 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] Split list.h and move rcu-protected lists into rculist.h
References: <478FBEA0.9090203@gmail.com>	<478FBEEA.6040000@gmail.com>	<20080201155826.a2d308c1.akpm@linux-foundation.org>	<47A470F9.9060708@gmail.com>	<20080202111516.5cbd0880.akpm@linux-foundation.org>	<47A57F25.5070902@gmail.com> <20080203010013.04bc601e.akpm@linux-foundation.org>
In-Reply-To: <20080203010013.04bc601e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 03 Feb 2008 09:45:25 +0100 Franck Bui-Huu <vagabon.xyz@gmail.com> wrote:
> 
>> Andrew Morton wrote:
>>> On Sat, 02 Feb 2008 14:32:41 +0100 Franck Bui-Huu <vagabon.xyz@gmail.com> wrote:
>>>> Do you think it's better ?
>>> Could.  I'd suggest that you redo the header-file split patch around the
>>> 2.6.25-rc1 timeframe, test it carefully then let's get it in then.
>>>
>> Does the mm tree also have a calm down period during release candidates ?
> 
> Yes, I try to not merge too much material late in the -rcs and in the merge
> window.  Often it's not practical to merge things anyway, because people
> prepare patches against mainline, which is ancient history...
> 
>> I have modified the patchset so now if rcu helpers are used from
>> rculist.h then fine otherwise gcc warns you that you're using the
>> helpers from list.h like this:
>>
>> init/foo.c:13: warning: ‘__deprecated_list_add_rcu’ is deprecated (declared at include/linux/rculist.h:76)
>>
>> But the build process doesn't fail anymore.
>>
>> For that I added some ugly hacks in list.h and rculist.h but they
>> definitively should be removed for mainline inclusion. I'm sending them
>> in response to this email.
> 
> I wouldn't bother, really.  Let's just get it as good as we can and slam it
> in.
> 
>> If we include this now, then people can have a chance to notice that
>> rculist.h exists and fix their stuffs until 2.6.25 release
>> candidates but I'll redo the patchset and give it some test around the
>> 2.6.25-rc1 timeframe anyway.
> 
> I'm just about finished compilation-testing for 2.6.24-mm1 which is a
> shame.  Please do a best-effort against 2.6.24-mm1 (hopefully I'll get that
> out tomorrow) and I'll slip it into -rc1 if it gets through cross-build
> testing without unfixable-with-my-patience-level problems.
> 

OK.

I'm waiting for 2.6.24-mm1 and resend the patchset for 2.6.25-rc1 after
some good testings on mm tree.

Thanks
		Franck
