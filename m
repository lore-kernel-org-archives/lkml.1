Return-Path: <linux-kernel-owner+w=401wt.eu-S933685AbXBYI6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685AbXBYI6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 03:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933683AbXBYI6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 03:58:21 -0500
Received: from www.osadl.org ([213.239.205.134]:37252 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933681AbXBYI6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 03:58:19 -0500
Subject: Re: 2.6.21-rc1: T60 resume from suspend to RAM issues
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, pavel@suse.cz, linux-pm@osdl.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com, mingo@redhat.com
In-Reply-To: <20070222233803.GA4447@mellanox.co.il>
References: <20070222233803.GA4447@mellanox.co.il>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 10:03:41 +0100
Message-Id: <1172394221.25076.359.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-23 at 01:38 +0200, Michael S. Tsirkin wrote:
> 1. After suspend to RAM, system wakes up but no screen.
> I can log in through ssh though.
> dmesg output at this point below.
> Works fine on 2.6.20 and below, with same .config
> .config and log file for this issue attached.
> 
> 2. As a separate test, I enabled DynTicks in .config.
> Seems to work fine but won't come out of suspend to memory at all:
> pressing Fn/F4 seems to have no effect.

Am I reading this correct, that the box is simply dead after supsend ?
Fn/F4 are the keys you use to resume, right ?

Hmm, I have no idea how dynticks should influence the keyboard wakeup.
The box is somewhere in the guts of the BIOS at this point.

	tglx


