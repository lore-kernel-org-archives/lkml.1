Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbXFLKLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbXFLKLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 06:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXFLKLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 06:11:37 -0400
Received: from smtp4.netcabo.pt ([212.113.174.31]:38368 "EHLO
	exch01smtp12.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752003AbXFLKLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 06:11:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah5FAJsNbkZZmGIhQWdsb2JhbACHM4gOAQEBPQ
Message-ID: <35572.194.65.103.1.1181643050.squirrel@www.rncbc.org>
In-Reply-To: <1181603306.8176.183.camel@chaos>
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org> 
    <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu> 
    <46574DE4.2080900@rncbc.org> <1180195709.4264.7.camel@chaos> 
    <4658A4F4.1080204@rncbc.org>  <46660369.2070104@rncbc.org> 
    <1181317625.4404.332.camel@chaos> 
    <59605.213.13.107.141.1181326897.squirrel@www.rncbc.org> 
    <1181328636.4404.335.camel@chaos>  <466DA42A.6010600@rncbc.org> 
    <1181591122.8176.159.camel@chaos> 
    <1181591733.11539.217.camel@imap.mvista.com> 
    <466DB581.8050306@rncbc.org>  <1181596473.8176.162.camel@chaos> 
    <466DBDC2.8030509@rncbc.org>  <1181598178.8176.180.camel@chaos> 
    <1181601280.11539.219.camel@imap.mvista.com>
    <1181603306.8176.183.camel@chaos>
Date: Tue, 12 Jun 2007 11:10:50 +0100 (WEST)
Subject: Re: 2.6.21-rt2..8 troubles
From: "Rui Nuno Capela" <rncbc@rncbc.org>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Daniel Walker" <dwalker@mvista.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-OriginalArrivalTime: 12 Jun 2007 10:11:33.0306 (UTC) FILETIME=[0D85A9A0:01C7ACDA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, June 12, 2007 00:08, Thomas Gleixner wrote:
> On Mon, 2007-06-11 at 15:34 -0700, Daniel Walker wrote:
>
>> On Mon, 2007-06-11 at 23:42 +0200, Thomas Gleixner wrote:
>>
>>> On Mon, 2007-06-11 at 22:25 +0100, Rui Nuno Capela wrote:
>>>
>>>> Nope. It's a Fujitsu-Siemens Amilo Si 1520 -- Intel Core2 Duo
>>>> T7200@2.0Ghz.
>>>>
>>>
>>> Yeah, there are Dell ones which have similar or worse symptoms.
>>>
>>>
>>>> Works great with 2.6.21-rt1, and 2.6.22-rc4-hrt5, but that you
>>>> already know :)
>>>
>>> Ok. I go back and figure out which differences we have between
>>> 2.6.21-rt>8 and the -hrt queue.
>>>
>>
>> Are you sure it's strictly and HRT issue? I didn't see a
>> !CONFIG_HIGH_RES_TIMERS test ..
>>
>
> The main difference between -rt1 and -rt2 was the update of -hrt, which
> not only affects CONFIG_HIGH_RES_TIMERS. There are enough
> CONFIG_HIGH_RES_TIMERS=n related changes to clock events and friends as
> well.
>

In deed, FWIW and IIRC, I can confirm that the show-stopper problem was
still present when tried with CONFIG_HIGH_RES_TIMERS not set (=N).

Bye now.
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
