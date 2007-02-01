Return-Path: <linux-kernel-owner+w=401wt.eu-S1422960AbXBATfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422960AbXBATfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 14:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422961AbXBATfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 14:35:20 -0500
Received: from www.osadl.org ([213.239.205.134]:56379 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422960AbXBATfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 14:35:19 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Mattia Dongili <malattia@linux.it>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <20070131232130.GC4137@inferi.kami.home>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <20070131215241.GB2890@inferi.kami.home>
	 <20070131232130.GC4137@inferi.kami.home>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 20:36:12 +0100
Message-Id: <1170358572.29240.292.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 00:21 +0100, Mattia Dongili wrote: 
> yes, slowness is gone. Any useful information I can provide?

Can you please try with CONFIG_ACPI_PROCESSOR=y instead of =m ? This
should make the slowness go away too.

I think I know what happens. I try to reproduce with
CONFIG_ACPI_PROCESSOR=m.

	tglx


