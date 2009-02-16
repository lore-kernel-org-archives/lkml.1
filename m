Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZBPUIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZBPUIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZBPUIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:08:13 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:17073 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZBPUIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:08:12 -0500
MIME-Version: 1.0
In-Reply-To: <20090216093108.078aac35@infradead.org>
References: <200902160010.16955.rjw@sisk.pl>
	 <200902160806.17901.oliver@neukum.org>
	 <20090216074048.6d70f17c@infradead.org>
	 <200902161748.09208.oliver@neukum.org>
	 <20090216093108.078aac35@infradead.org>
Date: Mon, 16 Feb 2009 15:08:09 -0500
Message-ID: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
Subject: Re: [RFD] Automatic suspend
From: Kyle Moffett <kyle@moffetthome.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 12:31 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 16 Feb 2009 17:48:06 +0100 Oliver Neukum <oliver@neukum.org> wrote:
>> Should there be a channel through which drivers can tell user space
>> what the consequences in terms of reaching a sleep state are if a
>> service is requested?
>
> Personally, I don't think so.
> Think about it: what would userspace do?
> Not ask for the functionality if it means no sleep state?
> Maybe it should just never ask for it then as a required functionality!

Userspace may not have a useful decision-making capability regarding
functionality versus power-saving, but the user it's talking to might!

I think it would be very useful to have a mechanism for userspace to
find out "Link detection on this NIC costs ~50mW" and "No link has
been detected for the last 15 minutes", so that it can compile all
that sort of information and prompt the user what devices they would
like to disable.  Perhaps an "airline mode" sort of thing?

Cheers,
Kyle Moffett
