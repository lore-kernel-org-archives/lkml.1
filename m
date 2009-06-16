Return-Path: <linux-kernel-owner+w=401wt.eu-S936338AbZFPGNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936338AbZFPGNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757785AbZFPGNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:13:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36997 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbZFPGM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:12:58 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5647"; a="19467009"
From: davidb@quicinc.com
Date: Mon, 15 Jun 2009 23:12:46 -0700
To: Ben Leslie <benno@benno.id.au>
Cc: Brian Swetland <swetland@google.com>, Pavel Machek <pavel@ucw.cz>,
       Nicolas Pitre <nico@cam.org>, Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, lkml <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090616061246.GA10145@huya.quicinc.com>
Mail-Followup-To: Ben Leslie <benno@benno.id.au>,
	Brian Swetland <swetland@google.com>, Pavel Machek <pavel@ucw.cz>,
	Nicolas Pitre <nico@cam.org>, Ryan Mallon <ryan@bluewatersys.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Tony Lindgren <tony@atomide.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	David Miller <davem@davemloft.net>,
	lkml <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk" <linux-arm-kernel@lists.arm.linux.org.uk>
References: <4A31AECA.6070303@bluewatersys.com> <alpine.LFD.2.00.0906112138090.31536@xanadu.home> <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com> <20090612103521.GD18682@elf.ucw.cz> <a55d774e0906120344p57226dd4ve526f274a2bf7c8e@mail.gmail.com> <a55d774e0906130005v5a35aa60ybabde470ff44cf77@mail.gmail.com> <20090615162150.GC6842@huya.quicinc.com> <17b28da20906151525q1d8f10daj734faacf5dafda12@mail.gmail.com> <20090615223941.GA8974@huya.quicinc.com> <17b28da20906151641q352fd44fme0e7ddf347cf0b93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17b28da20906151641q352fd44fme0e7ddf347cf0b93@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 04:41:14PM -0700, Ben Leslie wrote:

> I would say that the binary there is pretty much completely redundant now.
> Any new busybox 'for android' should probably build against the Android
> C library, with the Android version of gcc etc. My contribution was done
> before any of the Android source was available, and was compiled with
> the codesourcery gcc compiler.

A coworker spent a day or so trying to get this working and ran
into a lot of difficulties.  Bionic is missing a lot of things
that just aren't needed by Android, and busybox makes a lot of
assumptions about the C library.  It'd be nice to have, but I
think it would be a good amount of work.  For now, we're just
living with a static glibc version.

David
