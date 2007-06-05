Return-Path: <linux-kernel-owner+w=401wt.eu-S1762704AbXFEBCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762704AbXFEBCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 21:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759426AbXFEBCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 21:02:17 -0400
Received: from ozlabs.org ([203.10.76.45]:37722 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbXFEBCQ (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 21:02:16 -0400
Subject: Re: Interesting interaction between lguest and CFS
From: Rusty Russell <rusty@rustcorp.com.au>
To: Olof Johansson <olof@lixom.net>
Cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20070604225827.GA4280@lixom.net>
References: <20070604173710.GR11166@waste.org>
	 <20070604225827.GA4280@lixom.net>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 11:02:00 +1000
Message-Id: <1181005320.25878.68.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 17:58 -0500, Olof Johansson wrote:
> On Mon, Jun 04, 2007 at 12:37:10PM -0500, Matt Mackall wrote:
> > With 2.6.22-rc3-mm1, I've got a long-running video transcoding going
> > on. In other windows, I'm compiling, reading email, etc. with no
> > noticeable problems.
> > 
> > If I fire up lguest and leave it sitting at a shell prompt for a
> > couple moments, when I return to type something at the prompt, it can
> > take 2-3 seconds for my input to echo. Once it starts responding,
> > typing latency disappears. Suspend the other app and the latency
> > disappears.
> > 
> > The system isn't swapping and has basically no I/O load.
> 
> Is this on hvc console? The hvc driver was recently modified to back off
> it's timing interval when there's no input, the max value is 2 seconds.
> 
> See b791072ba3c3b29bab1890963bde52eb944a8451 for the changes in question.

Hmm, I thought that was only supposed to happen for "interruptless"
consoles?

Rusty.

