Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbYB1Sy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbYB1Sy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYB1Syt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:54:49 -0500
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:23913 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbYB1Sys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:54:48 -0500
From: Frans Pop <elendil@planet.nl>
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: Intel 945GM: 2.6.25-rc3 report (with a possible regression)
Date: Thu, 28 Feb 2008 19:54:44 +0100
User-Agent: KMail/1.9.7
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <1204056556.7745.22.camel@localhost> <200802281650.02471.elendil@planet.nl> <1204223005.32412.1.camel@localhost>
In-Reply-To: <1204223005.32412.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802281954.45351.elendil@planet.nl>
X-OriginalArrivalTime: 28 Feb 2008 18:54:45.0921 (UTC) FILETIME=[62CB5110:01C87A3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 February 2008, Romano Giannetti wrote:
> On Thu, 2008-02-28 at 16:50 +0100, Frans Pop wrote:
> > > Could this account to the LCD/CRT switching problem to?
> >
> > I'm afraid I can't help you there.
> >
> > As I said before, the only way to make sure is to see if the problem
> > gets solved if you boot the system with an older kernel version.
>
> Well, in this case I do not think it ever worked, so it's not a
> regression.

Ah, OK. That wasn't clear to me.
If it's not a regression, tracing the problem will be much harder.

The best way to start is probably just to google to see if other people with 
the same laptop or video controller have the same issues (and maybe 
solutions). Look for installation reports for your laptop model for 
example.

> But still would it be nice to solve it... thanks anyway! 

I have had LCD/VRT switching issues with my laptop as well (a Toshiba 
Satellite A40). The Fn key did always work, but the output after switching 
would be garbled and I could not switch back. This was finally fixed about 
a year ago with the new Intel drivers and xrandr 1.2.

Your problem may be totally different though and could possibly be related 
to the function keys, or indeed to the BIOS.
Note that some laptops need special kernel modules or user space programs to 
be loaded for the Fn keys to be supported. Have you checked for that?
