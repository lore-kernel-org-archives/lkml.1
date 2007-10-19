Return-Path: <linux-kernel-owner+w=401wt.eu-S966509AbXJSHyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966509AbXJSHyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764736AbXJSHyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:54:46 -0400
Received: from havoc.gtf.org ([69.61.125.42]:45101 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763353AbXJSHyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:54:45 -0400
Date: Fri, 19 Oct 2007 03:54:43 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 0/9] Remove 'irq' argument from all irq handlers
Message-ID: <20071019075443.GA6407@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


WARNING NOT FOR MERGE WARNING NOT FOR MERGE WARNING NOT FOR MERGE

This posting is just to demonstrate something that I have been keeping
alive in the background.  I have no urge to push it upstream anytime
soon.

The overwhelming majority of drivers do not ever bother with the 'irq'
argument that is passed to each driver's irq handler.

Of the minority of drivers that do use the arg, the majority of those
have the irq number stored in their private-info structure somewhere.

There are a tiny few -- a couple Mac drivers -- which do weird things
with that argument, but that's it.

For the large sweeps through the tree, these patches are grouped into
"trivial" changes -- simply removing the unused irq arg -- or all other
changes.

   [IRQ ARG REMOVAL] core interrupt delivery infrastructure updates
   [IRQ ARG REMOVAL] various non-trivial arch updates
   [IRQ ARG REMOVAL] trivial arch updates
   [IRQ ARG REMOVAL] non-trivial driver updates
   [IRQ ARG REMOVAL] trivial net driver updates
   [IRQ ARG REMOVAL] trivial sound driver updates
   [IRQ ARG REMOVAL] trivial scsi driver updates
   [IRQ ARG REMOVAL] trivial driver updates
   [IRQ ARG REMOVAL] x86-64 build fixes, cleanups

WARNING NOT FOR MERGE WARNING NOT FOR MERGE WARNING NOT FOR MERGE
