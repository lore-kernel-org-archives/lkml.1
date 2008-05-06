Return-Path: <linux-kernel-owner+w=401wt.eu-S932898AbYEFVeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898AbYEFVeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764158AbYEFVaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:30:46 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:59643 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665AbYEFVan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:30:43 -0400
Subject: Re: [PATCH] clocksource: shift helper
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, ralf@linux-mips.org,
       anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0805062303060.3318@apollo.tec.linutronix.de>
References: <20080501173123.444094226@mvista.com>
	 <alpine.LFD.1.10.0805060250410.3318@apollo.tec.linutronix.de>
	 <1210091954.17132.142.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805061854310.3318@apollo.tec.linutronix.de>
	 <1210106014.17132.172.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805062242020.3318@apollo.tec.linutronix.de>
	 <1210107675.17132.181.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805062303060.3318@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Tue, 06 May 2008 14:30:41 -0700
Message-Id: <1210109441.17132.193.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 23:19 +0200, Thomas Gleixner wrote:

> You - the patch submitter - have to provide useful information to
> those who review the patches and not the reviewers are supposed to
> decode your sloppy commit log.
> 
> "... which I pulled from the MIPS tree"
> 
> Why should I assume that this is from mainline ?

I'm not going to get into a long argument over this..

> > > I'm fine with the change itself, but it needs to move the code out of
> > > MIPS in the first place and not just duplicating code for no good
> > > reason.
> > 
> > I can work with Atsushi, but I still think the generic version should be
> > merged. We at least would need it in order to modify the mips code.
> 
> You can think what you want, it's not the way it works.
> 
> You duplicate code, so the first thing to do is to replace the code
> which you copied and make sure it is still fully functional. Then you
> can add a second user to make the point that the generic code move is
> actually useful. btw, pmtimer is the worst example for a good use case
> as everything there is constant so we can do it at compile time.

I can provide a patch that replaces the mips code instead of acpi_pm ..
Is that what your asking for?

Daniel

