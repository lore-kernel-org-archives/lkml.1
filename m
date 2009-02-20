Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZBTCjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZBTCjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZBTCjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:39:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:36890 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZBTCja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:39:30 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0902191659020.7953-100000@iolanthe.rowland.org>
References: <200902192215.18365.rjw@sisk.pl>
	 <Pine.LNX.4.44L0.0902191659020.7953-100000@iolanthe.rowland.org>
Date: Thu, 19 Feb 2009 18:39:29 -0800
Message-ID: <d6200be20902191839w1f74a962h30e859c8b2434f59@mail.gmail.com>
Subject: Re: [RFD] Automatic suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 2:08 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > It might have to be platform-specific.  The Android people seem to have a
>> > pretty good idea of what criteria will work for them.
>>
>> I'd really like to know in what situations Androind is supposed to suspend
>> automatically.
>
> It might be better to ask in what situations Android is _not_ supposed
> to sleep automatically.  In other words, in what situations is a
> wakelock acquired?  Since the whole system is only a phone, this
> question should have a reasonably well-defined answer.

On an android phone, any code that needs to run when the screen is off
must hold a wakelock (directly or indirectly). In general if an
application or the system is processing an event that may cause a user
notification (new email, incoming phone call, alarm, etc.) it needs to
prevent suspend. But, we also use wakelocks to upload stats or
download system updates in the background, and for media player or
(gps) data logging applications.

-- 
Arve Hjønnevåg
