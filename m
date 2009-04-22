Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZDVB6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZDVB6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 21:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZDVB6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 21:58:21 -0400
Received: from ozlabs.org ([203.10.76.45]:56474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZDVB6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 21:58:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Date: Wed, 22 Apr 2009 11:28:12 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Theodore Tso <tytso@mit.edu>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <200904201744.22572.rusty@rustcorp.com.au> <20090421133701.5b1cd303@bike.lwn.net>
In-Reply-To: <20090421133701.5b1cd303@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904221128.13534.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 05:07:01 am Jonathan Corbet wrote:
> On Mon, 20 Apr 2009 17:44:21 +0930
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > There are several readers: someone reviewing the patch, someone looking
> > for a specific bug, someone backporting, someone dealing with an API change,
> > someone bisecting. 
> 
> With this in mind, I've tried to make a relatively concise addition to
> the development process document.  How does the following look?

I like it, but will it help?

Fresh from an epic battle with printk, grep, debugging race conditions and
subtly confusing code, who among us can resist providing a blow-by-blow
account?  Leave the heroics unsung in a dry summary of the final patch?

Of course, you never see *me* use flowery prose!
Rusty.
