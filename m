Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbXCKTwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbXCKTwB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbXCKTwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:52:01 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57838 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710AbXCKTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:52:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
References: <20070311180342.GE24475@mellanox.co.il>
	<m1mz2jws83.fsf@ebiederm.dsl.xmission.com>
	<20070311183709.GB19601@mellanox.co.il>
Date: Sun, 11 Mar 2007 13:50:01 -0600
In-Reply-To: <20070311183709.GB19601@mellanox.co.il> (Michael S. Tsirkin's
	message of "Sun, 11 Mar 2007 20:37:09 +0200")
Message-ID: <m1mz2jv9ue.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@mellanox.co.il> writes:

> OK I guess. I gather we assume writing read-only registers has no side effects?
> Are there rumors circulating wrt to these?

I haven't heard anything about that, and if we are writing the same value back
it should be pretty safe.

I have heard it asserted that at least one version of the pci spec
only required 32bit accesses to be supported by the hardware.  One of
these days I will have to look that and see if it is true.  I do know
it can be weird for hardware developers to support multiple kinds of
decode.   As I recall for pci and pci-x at the hardware level the only
difference in between 32bit transactions and smaller ones is the state
of the byte-enable lines.

Eric
