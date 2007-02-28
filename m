Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbXB1VVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbXB1VVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbXB1VVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:21:30 -0500
Received: from www.osadl.org ([213.239.205.134]:48281 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752013AbXB1VV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:21:29 -0500
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070228211318.GB4301@mellanox.co.il>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <20070226220152.GA29575@stusta.de>  <20070228211318.GB4301@mellanox.co.il>
Content-Type: text/plain
Date: Wed, 28 Feb 2007 22:27:06 +0100
Message-Id: <1172698026.11473.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-28 at 23:13 +0200, Michael S. Tsirkin wrote:
> >Subject    : ThinkPad T60: no screen after suspend to RAM
> >References : http://lkml.org/lkml/2007/2/22/391
> >Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> >Handled-By : Ingo Molnar <mingo@elte.hu>
> >Status     : unknown
> 
> Just reproduced this in -rc2.
> Another thing I noticed:
> with 2.6.20, pressing Fn/F4 generates an ACPI event and triggers suspend to RAM.
> 
> On 2.6.21-rc2, after resume (when the box is accessible from network),
> pressing Fn/F4 again does not seem to have any effect.

Can you please get the dmesg output after resume via the network ?

	tglx


