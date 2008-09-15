Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYIOEjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYIOEjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 00:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYIOEjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 00:39:45 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:19008 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYIOEjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 00:39:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=LN4okbvBD747MsAmL1RxBgKdiaw1yccEMh2s2rQ3utcvumrBV4r6WpD0eUuLIg7muO
         +/SW7n2oVUrTfbssrRL88HnnfxFx6L/dnS8xeuMxPnA8YhFKibYxyIH6UUb/XrBvV97h
         vTeObhywMrL7WyCJqGYkwuaU5Z4SLAEI2rdeE=
Message-ID: <aff5deaf0809142139v42ff0025ub1c3bb5cdda83c84@mail.gmail.com>
Date: Sun, 14 Sep 2008 21:39:42 -0700
From: "S K" <nospamnoham@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: Unable to find files in include/asm-arm in the Linus's tree
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080914205538.27e7b1d4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <514e099a0809141825u34015891pa3f11267373ae818@mail.gmail.com>
	 <20080914205538.27e7b1d4.randy.dunlap@oracle.com>
X-Google-Sender-Auth: 30bd60636b01ab9a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

-SK

On Sun, Sep 14, 2008 at 8:55 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Sun, 14 Sep 2008 18:25:55 -0700 S K wrote:
>
>> Hi,
>>
>>   I think the copy paste of the terminal will explain it better:
>>
>> $ git status
>> # On branch master
>> nothing to commit (working directory clean)
>>
>> $ cat .git/config
>> [core]
>>         repositoryformatversion = 0
>>         filemode = true
>>         bare = false
>>         logallrefupdates = true
>> [remote "origin"]
>>         url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>>         fetch = +refs/heads/*:refs/remotes/origin/*
>> [branch "master"]
>>         remote = origin
>>         merge = refs/heads/master
>>
>> $ ls include/asm-arm/
>> plat-s3c  plat-s3c24xx
>>
>> Where are the other files? I'm totally confused. Doesn't Linus's tree
>> have the code for all archs?
>>
>> It obvious from the status I didn't delete them, but even a
>> $ git reset --hard HEAD
>> didn't help.
>
> Hi,
>
> Lots of arch-specific include/ directories were moved to arch/$ARCH/.
> E.g., arch/arm/include/asm/ contains lots of files and a few sub-directories.
>
> ---
> ~Randy
> Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
> http://linuxplumbersconf.org/
>
