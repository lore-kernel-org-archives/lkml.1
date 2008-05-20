Return-Path: <linux-kernel-owner+w=401wt.eu-S933373AbYETVR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373AbYETVR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758295AbYETVRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:17:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:38700 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761654AbYETVRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:17:13 -0400
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Trent Piepho <tpiepho@freescale.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>
In-Reply-To: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
Content-Type: text/plain
Date: Tue, 20 May 2008 17:16:59 -0400
Message-Id: <1211318219.8297.177.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-20 at 13:40 -0700, Trent Piepho wrote:
> There was some discussion on a Freescale list if the powerpc I/O accessors
> should be strictly ordered w.r.t.  normal memory.  Currently they are not.  It
> does not appear as if any other architecture's I/O accessors are strictly
> ordered in this manner.  memory-barriers.txt explicitly states that the I/O
> space (inb, outw, etc.) are NOT strictly ordered w.r.t. normal memory
> accesses and it's implied the other I/O accessors (e.g., writel) are the same.
> 
> However, it is somewhat harder to program for this model, and there are almost
> certainly a number of drivers using coherent DMA which have subtle bugs because
> the do not include the necessary barriers.
> 
> But clearly and change to this would be a subject for a different patch.

The current accessors should provide all the necessary ordering
guarantees...

Ben.


