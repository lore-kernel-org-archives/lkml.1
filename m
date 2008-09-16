Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbYIPV4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbYIPV4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 17:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYIPV4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 17:56:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYIPV4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 17:56:33 -0400
Message-ID: <48D02B5B.9090204@zytor.com>
Date: Tue, 16 Sep 2008 14:55:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] add DEFINE_LOGLEVEL_SETUP v3
References: <1221588085-30578-1-git-send-email-yhlu.kernel@gmail.com>	 <1221588085-30578-2-git-send-email-yhlu.kernel@gmail.com>	 <20080916190224.GA6115@joi>	 <86802c440809161404v4b59f1c8se1ac61f982a15dd@mail.gmail.com>	 <48D022B0.5080402@zytor.com> <86802c440809161428j2dfc9669g229a5bf23da63f34@mail.gmail.com>
In-Reply-To: <86802c440809161428j2dfc9669g229a5bf23da63f34@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Tue, Sep 16, 2008 at 2:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Yinghai Lu wrote:
>>> will come out one new version that hpa likes
>>>
>>> printk(KERN_PCI KERN_DEBUG "sadfasf\n");
>>>
>> Come to think about it, it might help migration pains if we put the prefixes
>> in the opposite order (KERN_DEBUG KERN_PCI).
>>
> according to the code flow, these two is the same... will double check it.
> 

The difference is that things that read the kernel log in userspace will 
be able to make partial sense of the latter, but not the former.  It 
will thus make the transition smoother.

	-hpa
