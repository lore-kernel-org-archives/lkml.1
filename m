Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbZJEIJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbZJEIJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbZJEIJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:09:08 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:63472 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758596AbZJEIJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uj+XzGsegdNE3dmQlTvFQaQcqWVutdTq59nwnzVc7PhMcEMOFrY9btUcEq41pGLDdf
         vMUxkztnnfYsouQV2vwQjNwbWbNMNSD+oMpyMTI3fCeKahJiLLpCvJBewepUxVU8YpPH
         QmpV+skr2w8wMxqcI+aRTKo3Kn0qP+hVEz8Ig=
Message-ID: <4AC9A979.2020007@tuffmail.co.uk>
Date: Mon, 05 Oct 2009 09:08:25 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] 2.6.32-rc1: various BUGs on resume from hibernation
References: <4AC8B4A8.3050601@tuffmail.co.uk>	<4AC8D568.9090103@tuffmail.co.uk>	<200910042247.43528.rjw@sisk.pl> <20091005095327.5ea9831b@strolchi>
In-Reply-To: <20091005095327.5ea9831b@strolchi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Seyfried wrote:
> On Sun, 4 Oct 2009 22:47:43 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>   
>> On Sunday 04 October 2009, Alan Jenkins wrote:
>>     
>>> Alan Jenkins wrote:
>>>       
>>>> I'm seeing a variety of BUGs on my EeePC 701 after hibernation.  
>>>> Sometimes they cause a hang during resume; sometimes they happen
>>>> just after resume.  It doesn't happen all the time either -  I've
>>>> just hibernated three times in a row with no problems.  It's most
>>>> perplexing.
>>>>         
>
>   
>> As I already asked in the Bugzilla, can you verify that this is
>> reproducible without KMS?
>>     
>
> This is important, there *are* hibernation issues with intel/KMS,
> e.g. http://bugs.freedesktop.org/show_bug.cgi?id=23701
>   

Sure, it's definitely on my suspect list.  I'm now booting with
i915.modeset=1, which gets me back to slow and flickery VT switches
again :-).

Thanks
Alan
