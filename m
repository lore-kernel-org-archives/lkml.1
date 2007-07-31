Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbXGaK1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbXGaK1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbXGaK1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:27:25 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:3950 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbXGaK1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:27:24 -0400
Date: Tue, 31 Jul 2007 11:27:25 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: John Sigler <linux.kernel@free.fr>
cc: linux-kernel@vger.kernel.org,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: BIOS implementors disabling the LAPIC
In-Reply-To: <46AEED9E.1050904@free.fr>
Message-ID: <Pine.LNX.4.64N.0707311119350.16158@blysk.ds.pg.gda.pl>
References: <46AEED9E.1050904@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007, John Sigler wrote:

> As far as I understand, the Local APIC was integrated directly to the CPU
> 12-15 years ago. Why would a BIOS implementor choose to disable it?

 Because they are lazy/incapable/out-of-time/select-your-favourite-excuse.  
For the chip to work you have to provide some minimal support in the 
firmware, in particular for the trickier paths of execution in the system 
management mode.  The system still works with the Local APIC disabled, so 
why bother?

> (And what does it mean to "disable" the LAPIC?)

 The LINT0 and LINT1 inputs of the APIC are routed straight to the INT and 
NMI inputs of the CPU respectively and the rest of the APIC logic becomes 
inactive (tri-stated, etc.).

  Maciej
