Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYBDWxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYBDWxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbYBDWx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:53:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:34556 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726AbYBDWx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:53:28 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-git: "x86: fix ioremap RAM check" causes - ACPI Error... Could not map memory
Date: Mon, 4 Feb 2008 17:52:30 -0500
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <200802040228.39880.lenb@kernel.org> <20080204122505.GA30564@elte.hu> <20080204122724.GA31186@elte.hu>
In-Reply-To: <20080204122724.GA31186@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802041752.31146.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2008 07:27, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > On Monday, 4 of February 2008, Len Brown wrote:
> > > > My HP nx6325 started printing the ACPI Error's below starting at 
> > > > the commit below.
> > > 
> > > Mine too.
> > 
> > does latest x86.git#mm fix it?
> 
> access coordinates:
> 
>   http://people.redhat.com/mingo/x86.git/README
> 
>

I do not see these warnings
in either the master or mm branches of x86.git.

Unless you tell me otherwise, I'm not going to worry about it.

thanks,
-Len

master:

commit 795d45b22c079946332bf3825afefe5a981a97b6
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Mon Feb 4 16:48:10 2008 +0100

    x86: fix RTC lockdep warning: potential hardirq recursion

mm:

commit b7e245f3a4f80a76a79bcff64319479ff8cd4091
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Feb 4 16:48:22 2008 +0100

    pci: pci_enable_device_bars() fix
