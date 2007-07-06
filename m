Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbXGFORj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbXGFORj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXGFORb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:17:31 -0400
Received: from smtp1.netcabo.pt ([212.113.174.28]:2852 "EHLO
	exch01smtp11.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752464AbXGFORa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:17:30 -0400
Message-ID: <37651.194.65.103.1.1183731362.squirrel@www.rncbc.org>
Date: Fri, 6 Jul 2007 15:16:02 +0100 (WEST)
Subject: Re: 2.6.21-rt2..8 troubles
From: "Rui Nuno Capela" <rncbc@rncbc.org>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Daniel Walker" <dwalker@mvista.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
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
    <35572.194.65.103.1.1181643050.squirrel@www.rncbc.org>
In-Reply-To: <35572.194.65.103.1.1181643050.squirrel@www.rncbc.org>
X-OriginalArrivalTime: 06 Jul 2007 14:17:28.0738 (UTC) FILETIME=[625BE820:01C7BFD8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm back but with good news this time :)...

On Tue, June 12, 2007 11:10, Rui Nuno Capela wrote:
> On Tue, June 12, 2007 00:08, Thomas Gleixner wrote:
>> On Mon, 2007-06-11 at 15:34 -0700, Daniel Walker wrote:
>>> On Mon, 2007-06-11 at 23:42 +0200, Thomas Gleixner wrote:
>>>> On Mon, 2007-06-11 at 22:25 +0100, Rui Nuno Capela wrote:
>>>>
>>>>> Nope. It's a Fujitsu-Siemens Amilo Si 1520 -- Intel Core2 Duo
>>>>> T7200@2.0Ghz.
>>>>>
>>>> Yeah, there are Dell ones which have similar or worse symptoms.
>>>>
>>>>> Works great with 2.6.21-rt1, and 2.6.22-rc4-hrt5, but that you
>>>>> already know :)
>>>>
>>>> Ok. I go back and figure out which differences we have between
>>>> 2.6.21-rt>8 and the -hrt queue.
>>>
>>> Are you sure it's strictly and HRT issue? I didn't see a
>>> !CONFIG_HIGH_RES_TIMERS test ..
>>
>> The main difference between -rt1 and -rt2 was the update of -hrt, which
>>  not only affects CONFIG_HIGH_RES_TIMERS. There are enough
>> CONFIG_HIGH_RES_TIMERS=n related changes to clock events and friends as
>>  well.
>
> In deed, FWIW and IIRC, I can confirm that the show-stopper problem was
> still present when tried with CONFIG_HIGH_RES_TIMERS not set (=N).
>

Although I'm still with my fingers crossed, I can tell that 2.6.21.5-rt19
(and -rt20) does behave far better now on the very same box.

I've more than 8 hours up and running now, without a single glimpse of the
bad symptoms, which used to show in a matter of minutes if not earlier
during init time.

Congratulations, -rt is usable again here and that just makes me happier :)

Cheers.
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org


