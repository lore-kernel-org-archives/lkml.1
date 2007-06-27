Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbXF0CoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbXF0CoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 22:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXF0CoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 22:44:08 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2733 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754060AbXF0CoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 22:44:07 -0400
Date: Tue, 26 Jun 2007 22:43:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070626181715.7264AD0002@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0706262241480.23864-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Roland McGrath wrote:

> I needed the attached patch on top of the bptest patch for the current
> code.  Btw, that is a very nice little tester!

I had already made some of those changes (the ones needed to make 
bptest build with the new hw_breakpoint code).  I'll add in the others.

> Below that is a patch to go on top of your current patch, with x86-64
> support.  I've only tried a few trivial tests with bptest (including an
> 8-byte bp), which worked great.  It is a pretty faithful copy of your i386
> changes.  I'm still not sure we have all that right, but you might as well
> incorporate this into your patch.  You should change the x86_64 code in
> parallel with any i386 changes we decide on later, and I can test it and
> send you any typo fixups or whatnot.

Right.  I may update a few comments...

Alan Stern

