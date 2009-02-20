Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZBTWnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZBTWnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZBTWn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:43:26 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:63917 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZBTWnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:43:25 -0500
MIME-Version: 1.0
In-Reply-To: <200902202149.25990.rjw@sisk.pl>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	 <20090220182213.GA1681@ucw.cz> <20090220182609.GA3289@srcf.ucam.org>
	 <200902202149.25990.rjw@sisk.pl>
Date: Fri, 20 Feb 2009 14:43:24 -0800
Message-ID: <d6200be20902201443l670f7ee4s8b9fd7d2400bbf9c@mail.gmail.com>
Subject: Re: [RFD] Automatic suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 12:49 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday 20 February 2009, Matthew Garrett wrote:
>> On Fri, Feb 20, 2009 at 07:22:15PM +0100, Pavel Machek wrote:
>> >  On Mon 2009-02-16 23:23:30, Matthew Garrett wrote:
>> > > On Tue, Feb 17, 2009 at 12:19:38AM +0100, Rafael J. Wysocki wrote:
>> > >
>> > > > This, again, seems to be a bit x86-centric. :-)  The Android people are telling
>> > > > us that on the hardware they deal with it does make sense to put the entire
>> > > > system to sleep even for relatively short periods of time, since the latencies
>> > > > involved are not too bad.
>> > >
>> > > Arve said that the power state was equivalent in idle and suspend, but
>> >
>> > ...for Arve's hardware. Not all embedded systems are like that, and
>> > OLPC / PCs are definitely not like that.
>>
>> And PCs have enough latency over suspend/resume that we can't do it
>> automatically in a non-intrusive manner anyway, so runtime pm is more
>> interesting there as well.
>
> Agreed.

That high latency is coupled to a large difference in power use. If
the latency of the lowest power state is too high to use from idle, it
makes it more important, not less important, to enter suspend when
possible.

-- 
Arve Hjønnevåg
