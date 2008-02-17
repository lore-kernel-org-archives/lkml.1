Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbYBQRsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbYBQRsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbYBQRsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:48:20 -0500
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:54389 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbYBQRsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:48:19 -0500
From: Frans Pop <elendil@planet.nl>
To: Daniel Barkalow <barkalow@iabervon.org>
Subject: Re: [REGRESSION 2.6.23] no vga console and no messages
Date: Sun, 17 Feb 2008 18:48:16 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <alpine.LNX.1.00.0802162042130.6093@iabervon.org> <E1JQe5R-0001cW-1a@faramir.fjphome.nl> <alpine.LNX.1.00.0802171134350.5496@iabervon.org>
In-Reply-To: <alpine.LNX.1.00.0802171134350.5496@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171848.16969.elendil@planet.nl>
X-OriginalArrivalTime: 17 Feb 2008 17:48:17.0505 (UTC) FILETIME=[46F81510:01C8718D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 February 2008, Daniel Barkalow wrote:
> On Sun, 17 Feb 2008, Frans Pop wrote:
> > Daniel Barkalow wrote:
> > > For some reason I can't see and don't know how to debug, in 2.6.23 on
> > > my server I don't get the vga console, but only get the dummy
> > > console.
> >
> > Please check if this bug report matches the issue you are seeing:
> > http://bugzilla.kernel.org/show_bug.cgi?id=9310
>
> I think mine might be different. I've got a vga parameter (vga=0x301),
> and mine disappears very early, before when you usually get "Console:
> colour VGA+ 80x25" (and I'm getting "Console: coloud dummy 80x25"
> instead). I've also got CONFIG_FB turned off entirely.

The main question is: do you have FRAMEBUFFER_CONSOLE_DETECT_PRIMARY enabled 
in you kernel config. If you do, I'd try disabling it.

> But if you've got any insight into how the console driver stuff works
> from troubleshooting your problem, I could use the hints...

Afraid not. Are you sure you have the correct framebuffer driver compiled 
into the kernel?

Please post your kernel config and the output of 'lspci -nn', so people can 
have a look.
