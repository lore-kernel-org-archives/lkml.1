Return-Path: <linux-kernel-owner+w=401wt.eu-S1751845AbZIHTHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbZIHTHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:07:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIHTG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:06:59 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:57462 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156AbZIHTG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:06:58 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net 2D9822C2C67
Message-ID: <4AA6AB52.8070206@arcor.de>
Date: Tue, 08 Sep 2009 22:06:58 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Pietikainen <pp@ee.oulu.fi>, Michael Buesch <mb@bu3sch.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu> <200909072051.13748.mb@bu3sch.de> <20090907205701.GA8590@elte.hu> <20090907232415.GA17182@ee.oulu.fi> <20090908080427.GA7070@elte.hu> <4AA6123F.7020704@arcor.de> <20090908101221.GA21533@elte.hu> <4AA634B0.3050302@arcor.de> <20090908113554.GA13630@elte.hu>
In-Reply-To: <20090908113554.GA13630@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 02:35 PM, Ingo Molnar wrote:
>
> * Nikos Chantziaras<realnc@arcor.de>  wrote:
>
>> [...] That would mean that you (or anyone else with an interest of
>> tracking this down) would follow the examples given (by me and
>> others, like enabling desktop compositing, firing up mplayer with
>> a video and generally reproducing this using the quite detailed
>> steps I posted as a recipe).
>
> Could you follow up on Frederic's detailed tracing suggestions that
> would give us the source of the latency?

I've set it up and ran the tests now.


> ( Also, as per lkml etiquette, please try to keep the Cc: list
>    intact when replying to emails. I missed your first reply
>    that you un-Cc:-ed. )

Sorry for that.


> A quick look at the latencytop output suggests a scheduling latency.
> Could you send me the kernel .config that you are using?

That would be this one:

     http://foss.math.aegean.gr/~realnc/kernel/config-2.6.31-rc9
