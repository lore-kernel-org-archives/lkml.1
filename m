Return-Path: <linux-kernel-owner+w=401wt.eu-S932588AbZDHTWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbZDHTWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 15:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760046AbZDHTVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 15:21:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45072 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbZDHTVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 15:21:51 -0400
From: "Hunter, Jon" <jon-hunter@ti.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronics.de>
Date: Wed, 8 Apr 2009 14:20:54 -0500
Subject: RE: [RFC] Dynamic Tick and Deferrable Timer Support
Thread-Topic: [RFC] Dynamic Tick and Deferrable Timer Support
Thread-Index: AcmArpYfQGI0iT+YRciR77NvDqGzKg3zaLww
Message-ID: <7B4574D56E4ADF438756313E9A172A87319DD3DC@dlee01.ent.ti.com>
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>
	 <20090114221624.76ee8aa4.akpm@linux-foundation.org>
	 <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com>
	 <7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com>
	 <7B4574D56E4ADF438756313E9A172A872CB82749@dlee01.ent.ti.com>
 <1233081369.28350.68.camel@jamoon.sc.intel.com>
In-Reply-To: <1233081369.28350.68.camel@jamoon.sc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n38JMDqu001857



> -----Original Message-----
> From: Pallipadi, Venkatesh [mailto:venkatesh.pallipadi@intel.com]
> Sent: Tuesday, January 27, 2009 12:36 PM
> To: Hunter, Jon
> Cc: Andrew Morton; linux-kernel@vger.kernel.org; Thomas Gleixner
> Subject: RE: [RFC] Dynamic Tick and Deferrable Timer Support
> 
> On Mon, 2009-01-26 at 13:41 -0800, Hunter, Jon wrote:
> > Pallipadi, Venkatesh <mailto:venkatesh.pallipadi@intel.com> wrote on
> Monday, January 26, 2009 1:48 PM:
> >
> > > I looked at your patch earlier, but I was concerned about few
> > > things and wanted to spend some more time on it. So, I did
> > > not reply earlier.
> >
> > No problem, I was not sure how clear my original email was :-)
> >
> > > The potential issues I see:
> > > - May be a bit theoritcal, as this may not happen in reality.
> > > But, with your change, if all the timers happen to be
> > > defrrable, timer wheel never advances and none of the timers
> > > expire. Not sure whether we need to handle this cleanly
> > > somehow or assume that not all the timers will be deferrable.
> >
> > So my understanding is, and please correct me if I am wrong, but as long
> as there is a timer interrupt then the timer wheel will advanced and all
> deferred timer functions will get executed. If that is the case then we
> should always be guaranteed a timer interrupt due to the implementation of
> the dynamic tick.
> >
> > The dynamic tick defines a maximum sleep period, max_delta_ns, which is
> a member of the "clock_event_device" structure. This governs the maximum
> time you could be asleep/idle for. Currently, the variable,
> "max_delta_ns", is defined as a 32-bit type (long) and for most
> architectures, if not all, this is configured by calling function
> "clockevent_delta2ns()". The maximum value that "max_delta_ns" can be
Pallipadi, Venkatesh wrote: 

> Ok. ï»¿Thinking about it a bit more, I think we can push this patch along.
> Thomas/Andrew, can one of you pick up this patch..
> 
> Thanks,
> Venki
> 
> Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 

Hi Andrew, Thomas,

Sorry to respond to this old thread, however, I wanted to see if you had any feedback on this patch. Let me know if you would like me to re-post. 

Cheers
Jon
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
