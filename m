Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYLAEc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYLAEc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 23:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYLAEcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 23:32:50 -0500
Received: from ozlabs.org ([203.10.76.45]:53097 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYLAEct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 23:32:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: lguest@ozlabs.org
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Date: Mon, 1 Dec 2008 15:02:35 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Avi Kivity <avi@redhat.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, jeremy@xensource.com,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20081104150729.GC21470@localhost> <20081129154516.GA26579@mailshack.com> <49318871.8010501@redhat.com>
In-Reply-To: <49318871.8010501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011502.37170.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 November 2008 04:52:41 Avi Kivity wrote:
> Alexander van Heukelum wrote:
> > I now did the benchmarks for the same -rc6 with hpa's 4-byte stubs
> > too. Same machine. It's significantly better than the other two
> > options in terms of speed. It takes about 7% less cpu to handle
> > the interrupts. (0.64% cpu instead of 0.69%.) I have to run now,
> > I'll let interpreting the histogram to someone else ;).
>
> This is noise. 0.05% cpu on a 1GHz machine servicing 1000 interrupt/sec
> boils down to 500 cycles/interrupt.  These changes shouldn't amount to
> so much (and I doubt you have 1000 interrupts/sec with a single disk)..

Sure, but smallest cache wins.  Which is why I thought hpa chose the 3 byte 
option.

> I'm sorry, but the whole effort is misguided, in my opinion.

Respectfully disagree.  I wouldn't do it, but it warms my heart that others 
are.  It's are not subtractive from other optimization efforts.

Cheers,
Rusty.
