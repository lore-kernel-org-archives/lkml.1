Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZBXNqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZBXNqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZBXNp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:45:58 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:27628 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbZBXNp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:45:57 -0500
Message-ID: <49A3FA10.4090801@turknet.net.tr>
Date: Tue, 24 Feb 2009 15:45:52 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: hooanon05@yahoo.co.jp
CC: Miklos Szeredi <miklos@szeredi.hu>, tomas@slax.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: New filesystem for Linux kernel
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <E1Lbvpf-0006fF-Tg@pomaz-ex.szeredi.hu> <11287.1235481490@jrobl>
In-Reply-To: <11287.1235481490@jrobl>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Feb 2009 13:45:52.0575 (UTC) FILETIME=[3598A4F0:01C99686]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hooanon05@yahoo.co.jp wrote:
> Miklos Szeredi:
>   
>> I think the biggest problem is too many features.
>>
>>    > git diff master...aufs2 | diffstat
>>     ...
>>     73 files changed, 23527 insertions(+), 7 deletions(-)
>>                       ^^^^^^
>> This is an unreviewable amount of code, it would make AUFS one of the
>> biggest filesystems on linux.
>>
>> The first step would be to separate out the very core functionality,
>> which should be a couple thousands of lines max.  And when that has
>> been accepted and stabilised, then you can start adding fancy
>> features.
>>     
>
> I have to admit aufs is big, but actually, as I wrote in the documents,
> aufs2 has already dropped several features. And I believe it is the core
> feature set. If aufs2 drops some more features, then both of users and
> reviewers will say it doesn't work in this case, in that case. I don't
> think you would like to review such unusable code in real world.
> For those who wants to begin with aufs2 principle (or basic
> architecture), I described and posted these documents.
>
>   
I think there is a misunderstanding or confusion about merging the code 
into the mainline. You needn't to drop some functionality/features to 
make your code small and to make it reviewed by mergers. You have to 
separate (Core FS functions, features etc.) your code into small pieces. 
So that, mergers will look, for first, your core FS functionality code 
to see that it *_breaks_* or *_touches_* any _*other areas of the 
kernel*_. If everything goes well, your main Core FS functionality code 
will be merged into the mainline. After that, you can send your 
feature/functionality codes one by one.



