Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZFBNTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZFBNTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZFBNTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:19:40 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:47619 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbZFBNTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:19:39 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: ttyACM0: 2.6.30-rc7 dies on device disconnect, strange echo (regressions)
Date: Tue, 2 Jun 2009 15:20:11 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-rc7-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090601101421.GA1914@elf.ucw.cz> <200906011434.57083.oliver@neukum.org> <20090602091912.GD15756@elf.ucw.cz>
In-Reply-To: <20090602091912.GD15756@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906021520.12487.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 2. Juni 2009 11:19:13 schrieb Pavel Machek:
> On Mon 2009-06-01 14:34:56, Oliver Neukum wrote:
> > Am Montag, 1. Juni 2009 13:31:51 schrieb Pavel Machek:
> > > Steps to reproduce:
> > >
> > > minicom /dev/ttyACM0
> > >
> > > Bug #2: try to interactivelly communicate with the other
> > > device. Notice that characters are echoed one character too late. You
> > > type "hello", but only "hell" appears. You press "!", "o" appears.
> > >
> > > Bug #1: while minicom is still connected, pull the USB cable. Machine
> > > locks hard.
> >
> > I can replicate neither bug with 2.6.30-rc7. Can you replicate it with
> > anything but openMOKO?
>
> So AT commands echo properly on USB modem or something? Bad :-(.

My cell phone echoes back arbitrary strings.

> I'm afraid I do not have another ACM device near me. I guess going
> through cdc-acm.c 's history would be relevant?

A bisection would indeed be very good.

	Regards
		Oliver

