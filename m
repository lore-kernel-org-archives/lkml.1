Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874Ab0A0DLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0A0DLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 22:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644Ab0A0DLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 22:11:21 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:62089 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab0A0DLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 22:11:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lYtgoEi72DuBGE7faPenoYYFFgISE3U9GrWhZ7vpTMLZ4AM1mdQXyCsTGuwwBMydQQ
         wH59awHLjzI3UQxV+C2Ho4T2m5lp8Zu6nxy4wjgeX8ysHOdHzCOtXludQP5D29PIjE9r
         c/6NsRRMO0aG+v3mUfSCxK8tGRNxTkS/fDpJM=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1001270043450.30977@pobox.suse.cz>
References: <1264549178-2874-1-git-send-email-justinmattock@gmail.com>
	 <alpine.LNX.2.00.1001270043450.30977@pobox.suse.cz>
Date: Wed, 27 Jan 2010 11:11:18 +0800
Message-ID: <2375c9f91001261911v3bdba302u75c42ef4d397c603@mail.gmail.com>
Subject: Re: [PATCH] Clean-up a few comments.
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 7:45 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 26 Jan 2010, Justin P. Mattock wrote:
>
>> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>> ---
>>  arch/x86/kernel/setup.c |    9 ++++-----
>>  1 files changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index f7b8b98..1bd37e9 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -245,7 +245,7 @@ struct edd edd;
>>  #ifdef CONFIG_EDD_MODULE
>>  EXPORT_SYMBOL(edd);
>>  #endif
>> -/**
>> +/*
>
> There are zillions of '**' comment starters in kernel sources.
>
>        $ git grep '/\*\*$' drivers/ | wc -l
>        15506
>
> So it doesn't seem to make sense to fix only this particular one.

Some of them are needed by kerneldoc generation, it doesn't make sense
to fix them.
