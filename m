Return-Path: <linux-kernel-owner+w=401wt.eu-S966047AbXCSRlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966047AbXCSRlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966049AbXCSRlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:41:16 -0400
Received: from www.osadl.org ([213.239.205.134]:41818 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966047AbXCSRlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:41:16 -0400
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stefan Prechtel <stefan.prechtel@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1174325803.13341.515.camel@localhost.localdomain>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <1174325803.13341.515.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 18:48:19 +0100
Message-Id: <1174326499.13341.517.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 18:36 +0100, Thomas Gleixner wrote:
> On Mon, 2007-03-19 at 18:10 +0100, Stefan Prechtel wrote:
> > So I tried to boot with nolapic on battery and with this option the
> > kernel (and system) starts as it should.
> > If you need more information, I will send it to you.
> 
> Can you please provide your .config and a bootlog from a boot with
> "nolapic" and without. Also please add apic=verbose to the commandline.
> 
> Can you please use Linus' latest git snaphost
> http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.21-rc4-git4.bz2
> 
> or pull from Linus' git repository.
> 
> You can please open a new bug (Category: Timers, Component: Other) on
> http://bugzilla.kernel.org and upload the files there, so we avoid
> distributing them via LKML.

Oh, a bootlog with ac plugged in would be great too. 

Also can you please enable CONFIG_SYSRQ and hit SysRq-Q once, when the
slowness kicks in.

Thanks,

	tglx


