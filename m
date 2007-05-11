Return-Path: <linux-kernel-owner+w=401wt.eu-S1761139AbXEKPZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139AbXEKPZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 11:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbXEKPZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 11:25:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54424 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755653AbXEKPZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 11:25:16 -0400
Date: Fri, 11 May 2007 11:25:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070328213951.BCD5B1801C4@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0705111122110.3383-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, Roland McGrath wrote:

> Sorry I've been slow in responding to your most recent version.
> I fell into a large hole and couldn't get out until I fixed some bugs.

Has the same thing happened again?  There hasn't been any feedback on the 
most recent version of hw_breakpoint emailed on April 13:

	http://marc.info/?l=linux-kernel&m=117661223820357&w=2

I think there are probably still a few small things wrong with it.  For
instance, the RF setting isn't right; I misunderstood the Intel manual.  
It should get set only when the latest debug interrupt was for an
instruction breakpoint.

Alan Stern

