Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbZKCBVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbZKCBVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 20:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbZKCBVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 20:21:51 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48641 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbZKCBVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 20:21:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H0Snu3VZl8YxMomTX+xDVOUuxUwt8ERs7hjzmUPwOS+4xOcadIBE2emjE+qYGdY0ul
         C1H/CENyC16mta7EeQMhpSa12ZXc56baZrgu2dRvdTW3vduU8BEmvR717Vkg3lme4t/R
         QFpNxeH807gWMHCcYovjvKqTYHrr/sZBP1xwg=
MIME-Version: 1.0
In-Reply-To: <4AEF81E2.3060403@cn.fujitsu.com>
References: <b741c2440911012346k7213befcida229606f10c0399@mail.gmail.com>
	 <4AEF81E2.3060403@cn.fujitsu.com>
Date: Tue, 3 Nov 2009 09:21:56 +0800
Message-ID: <b741c2440911021721o610ee4f1la123146e6e503d2d@mail.gmail.com>
Subject: Re: [PATCH 2/3] Fix the 'current css_set' problem in debug subsystem
From: Liu Aleaxander <aleaxander@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 9:05 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Liu Aleaxander wrote:
>>>From 61c93b1a66e43d44820e9b8d22ef0bec80dfc814 Mon Sep 17 00:00:00 2001
>> From: Liu Aleaxander <Aleaxander@gmail.com>
>> Date: Mon, 2 Nov 2009 14:30:07 +0800
>> Subject: [PATCH 2/3] Fix the 'current css_set' problem in debug subsystem
>>
>> In the current implementation, it always print the same information
>> no matter which group you are in. And this would be meaningless. So
>> we should make it print the information of the 'real' current one.
>>
>> Well, I am not sure it's the current one, but I'm sure it's the first
>> one of that cgroup.
>>
>
> I don't think there is a bug with current 'curent_css_set'. The
> "current" in all debug.current_xxx interfaces means "current task".
Yes, I know it means 'current task', but is this useful to print the
same things with two more files in all the cgroups?

> Besides we already print out a cgroup's css links through
> debug.cgroup_css_links, without showing the refcount of
> each css_set, but we can, if it can be useful:
>
>  # cat debug.cgroup_css_links
>  css_set c10d92e0
Good link:)

-- 
regards
Liu Aleaxander
