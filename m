Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0BTNmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 08:42:11 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:51365 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab0BTNmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 08:42:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=sDh90T5hU+21wNNBSTT0NJ2E/Iu0mQu2RGhtGW+HKfOaD8gKgoNNhluuc8++tIdYMW
         Y//B/gUQz22gtUy6ZJ8Le9BFCZEH79NA6Jr6Ju8fJZS10JaqhXJzkY9yjCnFLcWWt4uj
         +tAnLJsZXpk1vJBnDhwUROQbk3Y2nqB1Q7TaY=
Date: Sat, 20 Feb 2010 21:44:47 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
Message-ID: <20100220134447.GA3000@hack>
References: <1264740107.20211.53.camel@pasglop> <1266485775.6539.6.camel@jlt3.sipsolutions.net> <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain> <1266518735.3829.4.camel@jlt3.sipsolutions.net> <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com> <1266656213.5347.0.camel@jlt3.sipsolutions.net> <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com> <1266665331.12525.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1266665331.12525.0.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 12:28:51PM +0100, Johannes Berg wrote:
>On Sat, 2010-02-20 at 17:06 +0800, Américo Wang wrote:
>> On Sat, Feb 20, 2010 at 4:56 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Sat, 2010-02-20 at 15:13 +0800, Américo Wang wrote:
>> >
>> >> Does my following untested patch help?
>> >
>> > Sorry, no. I'll hook up a screen to the box after I return from the
>> > fresh market.
>> >
>> 
>> Are you sure there is no difference? :-/
>
>It deadlocks after
>
>Disabling non-boot CPUs ...
>
>Not sure if that counts as a difference...
>

I am not sure neither...

That message is displayed before shutting down the devices.

To verify, you can add some printk() in the end of
__cpufreq_remove_dev(), or enable CONFIG_CPU_FREQ_DEBUG.

Thanks!
