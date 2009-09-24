Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbZIXFDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbZIXFDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 01:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZIXFDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 01:03:01 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:40912 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZIXFDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 01:03:00 -0400
MIME-Version: 1.0
In-Reply-To: <20090924125000.d734a7b1.kamezawa.hiroyu@jp.fujitsu.com>
References: <1253540040-24860-1-git-send-email-ngupta@vflare.org>
	 <20090924104708.4f54ce4e.kamezawa.hiroyu@jp.fujitsu.com>
	 <4ABAE340.7010403@vflare.org>
	 <20090924125000.d734a7b1.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 24 Sep 2009 10:33:04 +0530
Message-ID: <d760cf2d0909232203i48e9dfceo990308a3fc4ab397@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] Add notifiers for various swap events
From: Nitin Gupta <ngupta@vflare.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 9:20 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:

>> >
>> > In general, notifier chain codes allowed to return NOTIFY_BAD.
>> > But this patch just assumes all chains should return NOTIFY_OK or
>> > just ignore return code.
>> >
>> > That's not good as generic interface, I think.
>>
>>
>> What action we can take here if the notifier_call_chain() returns an error (apart
>> from maybe printing an error)? Perhaps we can add a warning in case of swapon/off
>> events but not in case of swap slot free event which is called under swap_lock.
>>
> If return code is ignored, please add commentary at least.
>

okay.

> I wonder I may able to move memcg's swap_cgroup code for swapon/swapoff onto this
> notifier. (swap_cgroup_swapon/swap_cgroup_swapoff) But it seems not.
> sorry for bothering you.
>

Thanks for your comments!

Nitin
