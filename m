Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZGFGbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZGFGbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 02:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZGFGbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 02:31:37 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:59383 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZGFGbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 02:31:37 -0400
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2009 02:31:35 EDT
Message-ID: <4A5199F8.2010809@free.fr>
Date: Mon, 06 Jul 2009 08:30:16 +0200
From: Albert ARIBAUD <albert.aribaud@free.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
References: <20090703015554.GB5880@cr0.nay.redhat.com>	 <20090703071504.GG5880@cr0.nay.redhat.com>	 <412e6f7f0907030040v6133badat7058186a01d78f44@mail.gmail.com>	 <20090703081655.GH5880@cr0.nay.redhat.com>	 <412e6f7f0907030127u3d6806dfo9168600e7c71b241@mail.gmail.com>	 <20090703094229.GI5880@cr0.nay.redhat.com>	 <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>	 <4A4DDD54.9030206@free.fr>	 <412e6f7f0907051812q4b3d7bcfkff73c75da14a9cf4@mail.gmail.com>	 <4A51966C.3000102@free.fr> <412e6f7f0907052323g114ccbe0n2d17f3d870e42470@mail.gmail.com>
In-Reply-To: <412e6f7f0907052323g114ccbe0n2d17f3d870e42470@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao a écrit :
> On Mon, Jul 6, 2009 at 2:15 PM, Albert ARIBAUD<albert.aribaud@free.fr> wrote:
>>>
>>> pipe doesn't support llseek.
>> I wasn't thinking of actively seeking a file position, but simply that reads
>> and writes were independent (and both variable) in size, thus even without
>> (l)seeking, each endpoint has an independent read (resp. write) position to
>> track what's been read from (resp.written into) it at any time, and such a
>> position is, IIUC, single for a given fd, making a fd (a struct file)
>> insufficient for representing a pipe.
>>
>> Amicalement,
>> --
>> Albert.
>>
> pipe doesn't refer to pos when reading or writing. Please refer to
> pipe_read() and pipe_write() for more detail.

Hmm. Then how does pipe avoid overwriting what it's already written at the 
in endpoint, or reading twice the same data from the out endpoint?

Amicalement,
-- 
Albert.
