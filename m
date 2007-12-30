Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbXL3VVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbXL3VVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbXL3VVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:21:13 -0500
Received: from [194.117.236.238] ([194.117.236.238]:57752 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbXL3VVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:21:12 -0500
Date: Sun, 30 Dec 2007 23:18:18 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Richard Harman <richard@richardharman.com>
Cc: pharon@gmail.com, Rene Herman <rene.herman@keyaccess.nl>,
       "David P. Reed" <dpreed@reed.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071230231818.54877db8@linux360.ro>
In-Reply-To: <47780657.8020208@richardharman.com>
References: <47765D11.2040903@reed.com>
	<1198967334.5049.3.camel@iamer-laptop>
	<4776F6A0.9010801@keyaccess.nl>
	<1198979361.11150.2.camel@iamer-laptop>
	<20071230121725.11d05099@linux360.ro>
	<47780657.8020208@richardharman.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2007 15:57:59 -0500
Richard Harman <richard@richardharman.com> wrote:

> I think I may have a monkey wrench to throw into this, I finally got 
> around to testing the C1E patch, and the port80 patch.  End result: 
> port80 patch has zero effect on this laptop, and the C1E patch makes
> it stable.
> 
> AMD C1E patch 'force_amd_c1e' (disabling the workaround):
> 
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
> hpet0: 3 32-bit timers, 25000000 Hz
> Time: hpet clocksource has been installed.
> Clockevents: could not switch to one-shot mode: lapic is not
> functional. Could not switch to high resolution mode on CPU 0
> Clockevents: could not switch to one-shot mode: lapic is not
> functional. Could not switch to high resolution mode on CPU 1
> 
> And with the C1E workaround enabled, the kernel doesn't whine that
> the lapic isn't functional.
> 
> Those were the kernel messages I was trying to paste in my earlier 
> message, saying that the lapic works.  Do I have a DV6000 laptop that
> is a strange beast all in itself?

These two patches are not related in any way, they address two
different problems. My patch enables dynticks (and those messages don't
show up anymore), but it doesn't prevent your computer from locking up
as you said before.
