Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZEGTzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZEGTzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZEGTy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:54:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37829 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750938AbZEGTyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:54:55 -0400
Date: Thu, 7 May 2009 20:53:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507205357.1be739e1@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0905071404390.22107@qirst.com>
References: <1241462661.412.8.camel@alok-dev1>
	<4A00ADDE.9000908@zytor.com>
	<1241560625.8665.17.camel@alok-dev1>
	<alpine.DEB.1.10.0905071010170.24528@qirst.com>
	<1241716053.6311.1514.camel@laptop>
	<1241716422.6311.1524.camel@laptop>
	<1241716718.6311.1531.camel@laptop>
	<20090507173608.GC6693@linux.vnet.ibm.com>
	<1241717904.6311.1558.camel@laptop>
	<20090507180112.GE6693@linux.vnet.ibm.com>
	<alpine.DEB.1.10.0905071404390.22107@qirst.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 14:12:15 -0400 (EDT)
Christoph Lameter <cl@linux.com> wrote:

> To get back to the main point: I agree with Alok that the default HZ needs
> to be as low as possible. The remaining justification is the load
> balancing and possible context switching between multiple tasks contenting
> for a processor.
> 
> Is it enough if this occurs 100 times per second?

I would like to see evidence that it is, and by evidence I don't mean
"our virtual machine manager runs better" but good evidence that it isn't
affecting performance of any games, applications, video suites etc -
because we know it did in the past.

Even then its pointlessly jumping up and down and changing stuff rather
than fixing the real problem - which is jiffies.

Alan
