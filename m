Return-Path: <linux-kernel-owner+w=401wt.eu-S1763718AbZE3Uxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763718AbZE3Uxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 16:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbZE3Uxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 16:53:48 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:53532 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbZE3Uxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 16:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n9EPX+gHh4P/7rfJgTH2InkXwHi0Ql83dZGtlc5lOo5T48uDv/IM4s28Wy2Lrt9rEJ
         S3+oX/dZyvHnL2o7HazMH1XiYk7uo9Tmd1EeyEY0TPkFjXGDItN45I2JB/xkGpNcU8l0
         PM26ihrdVD6gpd/MT3RFEzCvlLLiv9BCjiJog=
MIME-Version: 1.0
In-Reply-To: <4A21999E.5050606@redhat.com>
References: <20090528090836.GB6715@elte.hu>
	 <20090530075033.GL29711@oblivion.subreption.com>
	 <4A20E601.9070405@cs.helsinki.fi>
	 <20090530082048.GM29711@oblivion.subreption.com>
	 <20090530173428.GA20013@elte.hu>
	 <20090530180333.GH6535@oblivion.subreption.com>
	 <20090530182113.GA25237@elte.hu>
	 <20090530184534.GJ6535@oblivion.subreption.com>
	 <20090530190828.GA31199@elte.hu> <4A21999E.5050606@redhat.com>
Date: Sat, 30 May 2009 23:53:47 +0300
X-Google-Sender-Auth: e23a82ca3b2bf3fd
Message-ID: <84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page 
	allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Larry H." <research@subreption.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On Sat, May 30, 2009 at 11:39 PM, Rik van Riel <riel@redhat.com> wrote:
>>> Have you benchmarked the addition of these changes? I would like to see
>>> benchmarks done for these (crypto api included), since you are proposing
>>> them.
>>
>> You have it the wrong way around. _You_ have the burden of proof here
>> really, you are trying to get patches into the upstream kernel. I'm not
>> obliged to do your homework for you. I might be wrong, and you can prove me
>> wrong.
>
> Larry's patches do not do what you propose they
> should do, so why would he have to benchmark your
> idea?

It's pretty damn obvious that Larry's patches have a much bigger
performance impact than using kzfree() for selected parts of the
kernel. So yes, I do expect him to benchmark and demonstrate that
kzfree() has _performance problems_ before we can look into merging
his patches.

                                     Pekka
