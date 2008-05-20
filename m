Return-Path: <linux-kernel-owner+w=401wt.eu-S934304AbYETWCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbYETWCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761443AbYETWCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:02:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:41849 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761100AbYETWC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:02:29 -0400
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Scott Wood <scottwood@freescale.com>
Cc: Trent Piepho <tpiepho@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <483344C0.3020703@freescale.com>
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
	 <1211318219.8297.177.camel@pasglop>  <483344C0.3020703@freescale.com>
Content-Type: text/plain
Date: Tue, 20 May 2008 18:02:18 -0400
Message-Id: <1211320938.8297.179.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-20 at 16:38 -0500, Scott Wood wrote:
> It looks like we rely on -fno-strict-aliasing to prevent reordering 
> ordinary memory accesses (such as to DMA descriptors) past the I/O 
> access.  It won't prevent reordering of memory reads around an I/O
> read, 
> though, which could be a problem if the I/O read result determines
> the 
> validity of the DMA buffer.  IMHO, a memory clobber would be better.

We probably want a full "memory" clobber then...

Ben.


