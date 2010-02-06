Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab0BFAkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 19:40:18 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:41603 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab0BFAkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 19:40:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pU6GcdnFtMvUJOYFBFiEP7qFobxgy8tUJ1XnNa1k2dUjd2Y2Y+WFJCCDANIGz4ZXbB
         9cBtV39DJKaPJVYbMfkuWnj8t5PD/LCiih992/hX0oaw+CizzCOLfmZZDB8a7L0cquQc
         nIbucVjtIbgYc0EHYurNBkDNXmJMeQSmiVq1I=
MIME-Version: 1.0
In-Reply-To: <1265381231.22001.673.camel@laptop>
References: <1265377920-5898-1-git-send-email-yong.zhang0@gmail.com>
	 <1265381231.22001.673.camel@laptop>
Date: Sat, 6 Feb 2010 08:40:10 +0800
Message-ID: <2674af741002051640q40cd157cj6af95f112cf50025@mail.gmail.com>
Subject: Re: [PATCH 0/4] correct onstack wait_queue_head declaration
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 10:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-02-05 at 21:52 +0800, Yong Zhang wrote:
>> Onstack wait_queue_head must be declared with
>> DECLARE_WAIT_QUEUE_HEAD_ONSTACK. Otherwise it will make lockdep
>> warn. So fix the wrong usage in this patchset.
>>
>> BTW, I split it to 4 patches to send to different maintainer
>> though it's due to the same issue. If you have no objection
>> on this kind of fix, I can also send it in one patch for some
>> simplification.
>>
>> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
>
> --no-chain-reply-to

Thanks for your reminder.  :)

Regards,
Yong
