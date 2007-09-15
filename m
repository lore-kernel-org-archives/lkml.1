Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbXIOJwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbXIOJwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 05:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbXIOJw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 05:52:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163AbXIOJw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 05:52:28 -0400
Date: Sat, 15 Sep 2007 02:52:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "tx tox" <t0mc4t1@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Cooper <ecc@cmu.edu>,
       linux-acpi@vger.kernel.org
Subject: Re: boot hangs with SMP, USB storage, and ACPI
Message-Id: <20070915025208.acb03ad3.akpm@linux-foundation.org>
In-Reply-To: <9b9c8e900709120600n3ffa9b6fn1bd514672d2e9bc1@mail.gmail.com>
References: <9b9c8e900709120600n3ffa9b6fn1bd514672d2e9bc1@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(cc restored.  Please always do reply-to-all)

(linux-acpi cc added)

On Wed, 12 Sep 2007 15:00:41 +0200 "tx tox" <t0mc4t1@gmail.com> wrote:

> On 12 Lip 2006, 00:41, Eric Cooper <e...@cmu.edu> wrote:
> > When I try toboota 2.6.17 kernel compiled forSMP(hyperthreading),
> > it hangs early in thebootsequence (after printing "FreeingSMP
> > alternatives").  The issue seems to be an interaction between a
> > USB-storage device (an empty flash card reader built into the
> > monitor) andACPI.
> >
> > It boots fine if I do any one of these:
> >   - physically disconnect theUSBdevice
> >   - disableUSBsupport in the BIOS
> >   -bootwithacpi=ht
> > but none of these is completely satisfactory.
> >
> > I'll happily supply more details, run tests, etc. if anyone is
> > interested in looking at this.  Thanks, and please CC me if you
> > respond.
> >
> > --
> > Eric Cooper             e c c @ c m u . e d u
> 
> 
> I have exactly the same problem
> This happens whenever i boot machine with reader on
> or usbstick plugged in.
> It happens with newer kernels as well.
> It is little bit annoying to reset machine just because i forgot
> to switch off the printer which has card reader equipped ;)
> some goofing with printks suggests ACPI as a place whenre it freezes.
> But i got no proof for that.
> Any suggestions are welcome.

Could you both please test 2.6.22 (or 2.6.23, soon) and if the bug is still
present, raise a report against acpi at bugzilla.kernel.org?

We'd be particularly internested in knowing if any earlier 2.6 kernel
worked OK and if so, which version(s).

Thanks.
