Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509Ab0AaRDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0AaRDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 12:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189Ab0AaRDs
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 12:03:48 -0500
Received: from mail-iw0-f173.google.com ([209.85.223.173]:39440 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0AaRDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 12:03:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OCehl3xt9DhkOrZrewXBUY6MctweOsW2o/Za8SkgT/B8rQ91D4eMaOOI9Ro+zuUpvQ
         STmY+Pp7VlzF0N9wJSdEC4Xkj1bGbBPRWsIosQl2b4/aISciFW1khaDbdFHfpWktl79I
         aMQF+yq9am5STzqL95iDZJZ8tfITuh7qShorM=
Message-ID: <4B65B7EF.2030203@gmail.com>
Date: Sun, 31 Jan 2010 11:03:43 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yuhong Bao <yuhongbao_386@hotmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>,<4B511B12.6010208@zytor.com> <SNT125-W39A63687E4BE4F52FAA517C3680@phx.gbl> <4B514656.5080805@zytor.com>
In-Reply-To: <4B514656.5080805@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 10:53 PM, H. Peter Anvin wrote:
> On 01/15/2010 06:06 PM, Yuhong Bao wrote:
>>
>>> The big difference isn't between HIGHMEM4G (no PAE) and HIGHMEM64G
>>> (PAE), it's between HIGHMEM and !HIGHMEM. That cutoff is ~892 MB for a
>>> stock 32-bit kernel.
>> Unfortunately most desktop/laptop systems nowadays ship with more than 1GB.Luckily, in the case of Atom netbooks that Linus mentioned, most Atom netbooks ship with only 1GB of RAM, partly due to MS's restrictions.However, disabling HIGHMEM will turn off NX which all Atom CPUs have, unless you turn CONFIG_PAE back on.
>
> Since 32 bits means that any machine with 1 GB more means HIGHMEM, the
> number of non-embedded machines that should run 32-bit kernels today is
> functionally the null set.  Unfortunately Linux distros have not
> properly promoted 64-bit kernels for 32-bit distros; although pure 64
> bits is better, it would be a *helluva* lot better if people stuck on 32
> bits for compatibility reasons had a saner alternative.

Unfortunately, the problem is, most of the Atom CPUs (except some of the 
desktop ones, and the newest Pine Trail chips) don't support 64-bit, 
which means there are a lot of new or almost-new machines that still 
need a 32-bit kernel.
