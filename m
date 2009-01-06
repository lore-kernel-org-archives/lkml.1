Return-Path: <linux-kernel-owner+w=401wt.eu-S1757778AbZAFWvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbZAFWvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbZAFWvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:51:00 -0500
Received: from styx.suse.cz ([82.119.242.94]:42110 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751705AbZAFWu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:50:58 -0500
Date: Tue, 6 Jan 2009 23:50:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jim Gettys <jg@laptop.org>
cc: Henrik Rydberg <rydberg@euromail.se>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       Peter Hutterer <peter.hutterer@who-t.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] input: Add a detailed multi-touch finger data	report
 protocol (rev2)
In-Reply-To: <1231266769.8379.79.camel@jg-vaio>
Message-ID: <alpine.LNX.1.10.0901062347480.5377@jikos.suse.cz>
References: <495804B1.10300@euromail.se> <1231266769.8379.79.camel@jg-vaio>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009, Jim Gettys wrote:

> 1) Does anyone know if Microsoft has actually made the proposal to the
> USB IF?  Is there anyone in the community watching/commenting on USB IF
> proposals?

This would be question for Greg.

> 2) do you want generic USB HID patches or do you want to, for now, 
> confine these to USB device specific drivers as much as possible?

We already have a lot of drivers for special HID devices that emit usages 
that have not been defined by HID standard. These drivers are independent 
on the underlying transport (USB, Bluetooth). Therefore all you ideally 
need to do is to add just another driver which hooks itself to HID bus and 
performs all that is needed in addition to what generic HID code does. 
There are lot of such drivers in drivers/hid/hid-*.c which you can use as 
examples. Please let me know if you have any further questions.

-- 
Jiri Kosina
SUSE Labs
