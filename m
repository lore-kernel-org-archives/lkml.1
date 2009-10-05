Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbZJEIKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbZJEIKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbZJEIKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:10:42 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:36041 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbZJEIKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HXvt27clzWR/0bUwAefTjdlMNq2COoIiwITH1WC82QG087sm2DGV4GTnfsKukcO4Tn
         Dfe5sXJ2f6ipBzMxyMraWfPOQKcIGauPdlCyLvw3ozuMt7xJZIZ8t8QwGwXtWXPfgbgS
         BEX6hyYxCjuLas17BWMXLu+8pbZZf7wOWu/X4=
MIME-Version: 1.0
In-Reply-To: <4AC9A979.2020007@tuffmail.co.uk>
References: <4AC8B4A8.3050601@tuffmail.co.uk> <4AC8D568.9090103@tuffmail.co.uk>
	 <200910042247.43528.rjw@sisk.pl> <20091005095327.5ea9831b@strolchi>
	 <4AC9A979.2020007@tuffmail.co.uk>
Date: Mon, 5 Oct 2009 09:10:03 +0100
Message-ID: <9b2b86520910050110h3087f80dl46d1b61ef3f8f9d1@mail.gmail.com>
Subject: Re: [linux-pm] 2.6.32-rc1: various BUGs on resume from hibernation
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/09, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
> Stefan Seyfried wrote:
>> On Sun, 4 Oct 2009 22:47:43 +0200
>> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>>
>>> On Sunday 04 October 2009, Alan Jenkins wrote:
>>>
>>>> Alan Jenkins wrote:
>>>>
>>>>> I'm seeing a variety of BUGs on my EeePC 701 after hibernation.
>>>>> Sometimes they cause a hang during resume; sometimes they happen
>>>>> just after resume.  It doesn't happen all the time either -  I've
>>>>> just hibernated three times in a row with no problems.  It's most
>>>>> perplexing.
>>>>>
>>
>>
>>> As I already asked in the Bugzilla, can you verify that this is
>>> reproducible without KMS?
>>>
>>
>> This is important, there *are* hibernation issues with intel/KMS,
>> e.g. http://bugs.freedesktop.org/show_bug.cgi?id=23701
>>
>
> Sure, it's definitely on my suspect list.  I'm now booting with
> i915.modeset=1

heh, I mean =0

, which gets me back to slow and flickery VT switches
> again :-).
>
> Thanks
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
