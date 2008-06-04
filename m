Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYFDGaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYFDGaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 02:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYFDGaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 02:30:13 -0400
Received: from mail161.messagelabs.com ([216.82.253.115]:14696 "EHLO
	mail161.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYFDGaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 02:30:11 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-7.tower-161.messagelabs.com!1212561009!11214594!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Wed, 4 Jun 2008 08:30:05 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
CC: Randy Dunlap <randy.dunlap@oracle.com>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Message-ID: <20080604063005.GA22952@digi.com>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local> <20080523055527.GA28963@digi.com> <20080523104454.4e2af6ec@bluebox.local> <20080523091009.GA22821@digi.com> <20080523120308.7bec1e1c@bluebox.local> <20080523105604.GA23800@digi.com> <20080523135557.27fe4855@bluebox.local> <20080523113650.2467f2ee.randy.dunlap@oracle.com> <20080524004917.6a226e96@dilbert.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080524004917.6a226e96@dilbert.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 04 Jun 2008 06:30:06.0374 (UTC) FILETIME=[6DC73C60:01C8C60C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans-Jürgen,

> Sometimes it is necessary to enable/disable the interrupt of a UIO device
> from the userspace part of the driver. With this patch, the UIO kernel driver
> can implement an "irqcontrol()" function that does this. Userspace can write
> an s32 value to /dev/uioX (usually 0 or 1 to turn the irq off or on). The
> UIO core will then call the driver's irqcontrol function.
IMHO it would make sense to demand that irqcontrol() is idempotent and
then call irqcontrol(ON) before blocking in read and poll.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
