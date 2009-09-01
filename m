Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbZIAQIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbZIAQIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZIAQIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:08:13 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:64359 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbZIAQIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:08:12 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19wopkrRBVFxIX6ugZ8E/U/
Date: Tue, 1 Sep 2009 09:08:02 -0700
From: Tony Lindgren <tony@atomide.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Hiremath, Vaibhav" <hvaibhav@ti.com>,
       "Syed Mohammed, Khasim" <khasim@ti.com>,
       Steve Sakoman <sakoman@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: Re: [PATCH 00/18] OMAP: DSS2: Intro
Message-ID: <20090901160801.GB14646@atomide.com>
References: <1251462337-12531-1-git-send-email-tomi.valkeinen@nokia.com> <4A9B96A7.5040005@gmail.com> <5e088bd90908310720p290ba68dwd6106a778fd7c740@mail.gmail.com> <0680EC522D0CC943BC586913CF3768C0037CE48136@dbde02.ent.ti.com> <19F8576C6E063C45BE387C64729E73940436A4A9B6@dbde02.ent.ti.com> <20090831155518.GC16876@atomide.com> <4A9CC8DB.2050803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9CC8DB.2050803@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Artem Bityutskiy <dedekind1@gmail.com> [090901 00:11]:
> On 08/31/2009 06:55 PM, Tony Lindgren wrote:
>> * Hiremath, Vaibhav<hvaibhav@ti.com>  [090831 07:44]:
>>>
>>>> -----Original Message-----
>>>> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
>>>> owner@vger.kernel.org] On Behalf Of Syed Mohammed, Khasim
>>>> Sent: Monday, August 31, 2009 8:11 PM
>>>> To: Steve Sakoman; Artem Bityutskiy; linux-kernel@vger.kernel.org;
>>>> linux-omap@vger.kernel.org Mailing List
>>>> Cc: Andrew Morton; Tony Lindgren; Tomi Valkeinen
>>>> Subject: RE: [PATCH 00/18] OMAP: DSS2: Intro
>>>>
>>>>
>>>>
>>>>> -----Original Message-----
>>>>> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
>>>> owner@vger.kernel.org] On Behalf Of Steve
>>>>> Sakoman
>>>>> Sent: Monday, August 31, 2009 7:50 PM
>>>>> To: Artem Bityutskiy
>>>>> Cc: Andrew Morton; Tony Lindgren; Tomi Valkeinen; linux-
>>>> kernel@vger.kernel.org; linux-
>>>>> omap@vger.kernel.org Mailing List
>>>>> Subject: Re: [PATCH 00/18] OMAP: DSS2: Intro
>>>>>
>>>>> On Mon, Aug 31, 2009 at 2:23 AM, Artem
>>>> Bityutskiy<dedekind1@gmail.com>  wrote:
>>>>>
>>>>>> We are using DSS2 in Nokia for about a year already. N900 is
>>>> using this
>>>>>> code, for example. Other (non-Nokia) projects are using DSS2 as
>>>> well.
>>>>>> The code was public for long time and was sent several times for
>>>> review.
>>>>>>
>>>>>> In any case,
>>>>>>
>>>>>> Tested-by: Artem Bityutskiy<artem.bityutskiy@nokia.com>
>>>>>
>>>>> Gumstix has also been shipping with DSS2 on their Overo product
>>>> for
>>>>> many months now.
>>>>>
>>>>> Tested-by: Steve Sakoman<steve@sakoman.com>
>>>>
>>>> If there is a concern on OMAP2 support, I can confirm that there is
>>>> no difference between OMAP2 and OMAP3 Display Subsystem from
>>>> Register level. So what ever works on OMAP3 DSS2 should straight
>>>> away work for OMAP2 as well.
>>>>
>>>> I agree with rest of the folks here, we should get DSS2 merged in
>>>> mainline. It is being extensively used on all OMAP3 platforms.
>>>>
>>> [Hiremath, Vaibhav] I am also agreeing with the point that we should merge the DSS2; it's now almost year we have migrated to DSS2. Most of our customers are based out of it.
>>
>> Yeh I agree this should get merged.
>>
>> I think it's best to merge this via the fb list and I've acked the
>> patches that I'm concerned with already.
>
> This would be a good suggestion if the fb list was alive, but it is not.
> Do you have a specific name of a maintainer?

Bummer, I don't know who should ack this then.

> Andrew,
>
> could you please help with merging this piece of (well written) code?
> Could you give your blessing to include it into linux-next now, and
> merge this during the next merge window?

Alternatively I can also pile it into the omap for-next branch if
Andrew prefers that.

It would be nice to get some fb people to ack the drivers/video/omap/
parts of the patch series though.

Tony 
