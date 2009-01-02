Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbZABQWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbZABQWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZABQWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:22:33 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59157 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbZABQWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:22:32 -0500
Date: Fri, 2 Jan 2009 17:22:20 +0100
From: Pavel Machek <pavel@suse.cz>
To: Frank Groeneveld <frankgroeneveld@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Kernel 2.6.28 regression: Hang after hibernate
Message-ID: <20090102162220.GB1555@ucw.cz>
References: <a00b9da20812281234u76da2ef5tb715f4c409eaf37c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a00b9da20812281234u76da2ef5tb715f4c409eaf37c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Today I tried the new kernel and found out it has a regression. With
> kernel 2.6.27 I never had problems resuming from hibernate, but with
> 2.6.28 it hangs. The output is something like this (it's not exactly,
> I skipped some words that are before the PCI lines):
> 
> PM: read .. MB in .. seconds
> SDA: Synchronizing SCSI cache
> r8169: PME# enabled
> PCI INT A disabled
> PCI INT D disabled
> PCI INT B disabled
> PCI INT C disabled
> PCI INT D disabled
> PCI INT A disabled
> Disabling non-boot CPUs
> CPU1 is now offline
> CPU1 is down
> CPU2 is now offline
> CPU2 is down
> CPU3 is now offline
> CPU3 is down
> SMP Alternatives: switching to UP code
> 
> I first thought it's the same as bug 12155, but I'm not sure it is.
> If there's any other ouput I can send to help, let me know.

Can you try with minimum config? And maybe !CONFIG_SMP?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
