Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZCIRNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZCIRNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZCIRNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:13:15 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40207 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZCIRNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:13:14 -0400
Date: Mon, 9 Mar 2009 13:12:43 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Mikhail Zolotaryov <lebon@lebon.org.ua>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc 4xx: DDR0_14[REDUC] decoded incorrectly
Message-ID: <20090309171243.GA26415@zod.rchland.ibm.com>
References: <49B54210.5040709@lebon.org.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B54210.5040709@lebon.org.ua>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 06:21:36PM +0200, Mikhail Zolotaryov wrote:
> Hi,
>
> according to the PPC440EPx Embedded Processor User Manual (rev 1.14)  
> DDR0_14[REDUC] bit has the following meaning:
>
> REDUC - Enable the half data path feature of the controller
> 0 = Standard operation using full 64/72-bit memory bus
> 1 = Memory data path width is 32/40 bits
>
> However, "1" is decoded as 64 bit (8 byte), "0" - as 32 bit (4 byte) bus  
> by the kernel code. My understanding is this is not correct - patch  
> attached.

You are missing the Signed-off-by tag that is needed.

Aside from that, I'm curious if you found this just through inspection, or
if you actually had a problem because of it.  Your fix seems correct, yet
I've had no problems with my boards at all.

josh
