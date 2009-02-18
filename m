Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbZBRPDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbZBRPDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZBRPDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:03:33 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:47927 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZBRPDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:03:32 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFD] Automatic suspend
Date: Wed, 18 Feb 2009 16:05:15 +0100
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902162144010.24097-100000@netrider.rowland.org> <200902180953.51171.oliver@neukum.org> <20090218065158.5efa8536@infradead.org>
In-Reply-To: <20090218065158.5efa8536@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902181605.18363.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 18 February 2009 15:51:58 schrieb Arjan van de Ven:
> On Wed, 18 Feb 2009 09:53:48 +0100
> Oliver Neukum <oliver@neukum.org> wrote:
> 
> > Am Wednesday 18 February 2009 00:26:53 schrieb Rafael J. Wysocki:
> > > > Another possibility is to set up independent runtime PM for the
> > > > transport and the device.  This means allowing the possibility
> > > > that the transport is suspended while its child (the device) is
> > > > not.  This is a little simpler (there's only one idle-timeout per
> > > > device, since the link is treated as an independent device), but
> > > > it violates the principle of never suspending a parent while
> > > > there is an active child.
> > > 
> > > Well, I think the first approach would be better.
> > 
> > I am afraid it wouldn't be. How do you deal with shared transports?
> > 
> 
> realistically, something like this you need to design like this
> Step 1) Assume the hardware is smart and can do this for you on the fly,
>         but it might need guidance.
>         (For many busses there are platforms that do this)
> Step 2) For hardware that is not smart, emulate the smartness in the
>         driver, with help of the subsystem. These two together have
>         the right knowledge to make such decisions.

But the transport and the driver may be in different subsystems, e.g.
usb storage.

	Regards
		Oliver


