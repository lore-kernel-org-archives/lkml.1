Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbXFECRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbXFECRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 22:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbXFECRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 22:17:10 -0400
Received: from lixom.net ([66.141.50.11]:51575 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757468AbXFECRJ (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 22:17:09 -0400
Date: Mon, 4 Jun 2007 21:23:20 -0500
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070605022320.GA5745@lixom.net>
References: <20070604173710.GR11166@waste.org> <20070604225827.GA4280@lixom.net> <1181005320.25878.68.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181005320.25878.68.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 11:02:00AM +1000, Rusty Russell wrote:
> On Mon, 2007-06-04 at 17:58 -0500, Olof Johansson wrote:
> > 
> > Is this on hvc console? The hvc driver was recently modified to back off
> > it's timing interval when there's no input, the max value is 2 seconds.
> > 
> > See b791072ba3c3b29bab1890963bde52eb944a8451 for the changes in question.
> 
> Hmm, I thought that was only supposed to happen for "interruptless"
> consoles?

Ok, my bad. I thought lguest was polled as well.


-Olof
