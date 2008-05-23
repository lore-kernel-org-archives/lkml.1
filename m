Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbYEWMER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbYEWMER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 08:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYEWMD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 08:03:59 -0400
Received: from mail161.messagelabs.com ([216.82.253.115]:10805 "EHLO
	mail161.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYEWMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 08:03:58 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-5.tower-161.messagelabs.com!1211544237!4179459!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Fri, 23 May 2008 14:03:22 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Message-ID: <20080523120322.GB6932@digi.com>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local> <20080523055527.GA28963@digi.com> <20080523104454.4e2af6ec@bluebox.local> <20080523091009.GA22821@digi.com> <20080523120308.7bec1e1c@bluebox.local> <20080523105604.GA23800@digi.com> <20080523135557.27fe4855@bluebox.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080523135557.27fe4855@bluebox.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 23 May 2008 12:03:22.0575 (UTC) FILETIME=[FF7C5DF0:01C8BCCC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

> > Otherwise the patch looks fine.
> 
> Thanks for your review! Could you add your Signed-off-by?
I don't consider my feed back valueable enough for a Signed-off-by, but
you can get an ...

> From: Hans J. Koch <hjk@linutronix.de>
> To: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@suse.de>,
> 	Jan Altenberg <jan.altenberg@linutronix.de>,
> 	Thomas Gleixner <tglx@linutronix.de>,
> 	Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>,
> 	Magnus Damm <magnus.damm@gmail.com>
> Subject: UIO: Add write function to allow irq masking
> Date: Thu, Fri, 23 May 2008 13:50:14 +0200
> 
> Sometimes it is necessary to enable/disable the interrupt of a UIO device
> from the userspace part of the driver. With this patch, the UIO kernel driver
> can implement an "irqcontrol()" function that does this. Userspace can write
> an s32 value to /dev/uioX (usually 0 or 1 to turn the irq off or on). The
> UIO core will then call the driver's irqcontrol function.
> 
> Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Acked-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>,

Best regards
Uwe
