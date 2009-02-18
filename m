Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbZBRWs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbZBRWs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbZBRWm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:42:26 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:38851 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760648AbZBRWmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:42:24 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFD] Automatic suspend
Date: Wed, 18 Feb 2009 23:44:05 +0100
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902162156380.24097-100000@netrider.rowland.org> <200902182217.48321.rjw@sisk.pl> <d6200be20902181435o1794007bpfbab1f9e41979bad@mail.gmail.com>
In-Reply-To: <d6200be20902181435o1794007bpfbab1f9e41979bad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902182344.12100.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 18 February 2009 23:35:26 schrieb Arve Hjønnevåg:
> >> Allowing user space to suspend input devices while they are still open
> >> is useful. The user-space code that reads from the input devices does
> >> not need to know if the device is suspended or not, and the kernel
> >> cannot auto suspend input devices based on inactivity.
> >
> > Hmm.  Why can't it?
> 
> Because they stop working. It is OK for us to turn off the touchscreen
> when the screen is off, but when the screen is on the user will touch
> items on the screen and expect them to respond. (We could also turn
> off the touchscreen when the keyguard is on, but we don't currently do
> this.)

This depends on the capabilities of the input device in question. Some
USB keyboards can be autosuspended under these conditions because
they can do remote wakeup.

	Regards
		Oliver
