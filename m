Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZCCAZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZCCAZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbZCCAZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:25:13 -0500
Received: from smtp-out.google.com ([216.239.33.17]:28330 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZCCAZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:25:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ZHjCl/zMAlnWeqP8GJvzF26mMrY12AxlazjTDk7cRjkBGnU/cLU0o4X5npBUXbQ22
	GJ8vlWEwi2yHMYwE4lkcg==
Message-ID: <49AC789D.5050209@google.com>
Date: Mon, 02 Mar 2009 16:23:57 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>,
       Containers <containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Linux@smtp1.linux-foundation.org
Subject: Re: [PATCH 0/4] cgroups: show correct file mode
References: <49AB40BF.4030706@cn.fujitsu.com>	<6599ad830903021019p3b29c173oc7772af6679d90e0@mail.gmail.com>	<20090303090950.60cea53a.kamezawa.hiroyu@jp.fujitsu.com>	<6599ad830903021615j6e1380e2l1544b67b187c1f5e@mail.gmail.com> <20090303092021.93e69b96.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090303092021.93e69b96.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 2 Mar 2009 16:15:51 -0800
> Paul Menage <menage@google.com> wrote:
> 
>> On Mon, Mar 2, 2009 at 4:09 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>>        int mode;
>>>        if (cft->mode)
>>>                mode = cft->mode;
>>>        else if (cft->write_xxx || .....)
>>>                mode = 0644;
>>>        else
>>>                mode = 0444;
>> Almost:
>>
>> int mode;
>> if (cft->mode) {
>>   mode = cft->mode;
>> } else {
>>   if (cft->write_xxx || ....)
>>     mode |= 0600;

0200 ?

>>   if (cft->read_xxx || ...)
>>     mode |= 0444;
>> }
>>
> Oh, I see. But int mode=0, at first ;)
> I have no objections but please forgive subsys to set mode=0644 explicitly.
> 
> Thanks,
> -Kame
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers

