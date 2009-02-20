Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZBTFfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZBTFfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 00:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbZBTFfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 00:35:42 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:16017 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZBTFfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 00:35:41 -0500
MIME-Version: 1.0
In-Reply-To: <20090216232329.GA15678@srcf.ucam.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	 <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com>
	 <20090216145948.6fea81c3@infradead.org>
	 <200902170019.40599.rjw@sisk.pl>
	 <20090216232329.GA15678@srcf.ucam.org>
Date: Thu, 19 Feb 2009 21:35:39 -0800
Message-ID: <d6200be20902192135y166eb90bt895c97c7b381c44c@mail.gmail.com>
Subject: Re: [RFD] Automatic suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 3:23 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Feb 17, 2009 at 12:19:38AM +0100, Rafael J. Wysocki wrote:
>
>> This, again, seems to be a bit x86-centric. :-)  The Android people are telling
>> us that on the hardware they deal with it does make sense to put the entire
>> system to sleep even for relatively short periods of time, since the latencies
>> involved are not too bad.
>
> Arve said that the power state was equivalent in idle and suspend, but
> that they preferred suspend because it stopped any periodic timers. I'd
> be more interested in making sure that unnecessary timers aren't running
> than focusing on automatically entering system-wide suspend - Nokia have
> been managing this since 2005 with good results.

I'm sure you can build a product with acceptable battery life without
suspend. The average power draw on the G1 while idle with everything
off is less than the power draw was in suspend on our previous
hardware. However, on the same hardware you get 40 days standby using
suspend versus 20 days using idle. If you turn on the radio and use
the device every day, this starts to become irrelevant since you are
lucky to get more than a few days standby time. However, if you
install an application that wakes up 60 times a second (to check if it
need to draw something on the screen) the difference between idle and
suspend becomes 10 hours versus 40 days, or 10 hours versus 3 days
with my use.

-- 
Arve Hjønnevåg
