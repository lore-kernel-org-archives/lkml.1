Return-Path: <linux-kernel-owner+w=401wt.eu-S1751559AbXDDVEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbXDDVEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbXDDVEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:04:25 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbXDDVEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:04:23 -0400
Date: Wed, 4 Apr 2007 14:04:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>
Subject: Re: [PATCH -mm] fix jiffies clocksource inittime
Message-Id: <20070404140404.3daa910b.akpm@linux-foundation.org>
In-Reply-To: <1175720027.17711.69.camel@localhost>
References: <1175716216.17711.59.camel@localhost>
	<20070404134310.12ad3ab8.akpm@linux-foundation.org>
	<1175720027.17711.69.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 13:53:47 -0700
john stultz <johnstul@us.ibm.com> wrote:

> > An option would be to test it in 2.6.22-rcX for a while, then backport to
> > 2.6.21.x.
> 
> I'm fine with this (also getting it into the next -mm would help). But
> I'd defer to others with stronger opinions.

No, I wouldn't wait around for -mm testing in a case like this.

Generally, if we plan on getting a patch into 2.6.x this late in the cycle,
I will slam it in asap so it gets as much testing as possible.

Oh well, fingers crossed - I'll add it to today's batch.
