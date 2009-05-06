Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZEFB0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZEFB0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 21:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZEFB0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 21:26:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:33420 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZEFB0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 21:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qsei117IJKagkBuY1ffm6FcaeF2mQW8lyMAH1sL4npaW4yCzfPE7QAUr106oZnKZHQ
         GV/x5JswBF+sW+F1Zaxk6VFrI08OeWX7cqqklPQzLOiNtz8jCeNybWar9126DbeLk7uV
         B/nEL9ulrgF/AwQaVAD5dbV7niUbzEj7ZHjhU=
MIME-Version: 1.0
In-Reply-To: <13a12eea0905040618u7fc48755hdbc3ea6d87c4d68c@mail.gmail.com>
References: <2891419e0905040356x53643144of77eeaa8c210dce7@mail.gmail.com>
	 <13a12eea0905040618u7fc48755hdbc3ea6d87c4d68c@mail.gmail.com>
Date: Wed, 6 May 2009 10:26:39 +0900
Message-ID: <2891419e0905051826p77cf211fmf5a6a0b8c65f5342@mail.gmail.com>
Subject: Re: [PATCH 0/2] range-bw : Another I/O scheduling policy of dm-ioband 
	(v1)
From: Dong-Jae Kang <baramsori72@gmail.com>
To: Chris Snook <chris.snook@gmail.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, righi.andrea@gmail.com,
       menage@google.com, balbir@linux.vnet.ibm.com,
       guijianfeng@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       lizf@cn.fujitsu.com, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, nauman@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, corsetproject@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Chris Snook

2009/5/4 Chris Snook <chris.snook@gmail.com>:
> On Mon, May 4, 2009 at 6:56 AM, Dong-Jae Kang <baramsori72@gmail.com> wrote:
>> range-bw has two kinds of operation modes, min-max and max mode.
>> Min-max mode is to supports guaranteeing the minimum I/O requirement
>> and limitation of unnecessary I/O bandwidth at the same time. And max
>> mode is to support only limitation. So in case of min-max mode, you
>> need to configure min-bw and max-bw values and in case of max mode,
>> configure only max-bw.
>
> Please forgive me if I missed a previous discussion, but how is max
> mode different from min-max mode with a minimum of zero?  I understand
> that there may be some special-case optimizations you can do
> internally, but it's unclear to me why you need two different
> interfaces.
>

Thank you for your good comments,

As you asked,
max mode is actually same with min-max mode with a zero minimum value.
It is only to consider the aspect of user interface now.
the reason is as below
according to the usage case, some users may be interested in
guranteeing the minimum BW
and limitation of maximum BW at the same time (the  basic
fuctionalilty of range-bw), but, some
users can be interested in only limitation of BW to reserve the BW for
another service.

actually, I was overlooking that users are confused with the two kinds
of interface

So, your comments will be related with my future work :)
if two kinds of mode is confused or unnecessary to people,
I will re-consider about supporting the unified interfaces as you pointed
or I try to optimize the scheduling policy for max mode.
and this work will be applied in next release of range-bw.

Thank you, Chris Snook

-- 
Best Regards,
Dong-Jae Kang
