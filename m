Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYAPUz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYAPUz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYAPUzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:55:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59420 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYAPUzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:55:13 -0500
Message-ID: <478E6C20.2030005@zytor.com>
Date: Wed, 16 Jan 2008 15:42:08 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org,
       Russell King <rmk+serial@arm.linux.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 2/2] 8250_pnp: register x86 COM ports at the conventional
 ttyS names
References: <9MjWa-VI-9@gated-at.bofh.it> <9MjWb-VI-11@gated-at.bofh.it> <9MlEG-3Mx-13@gated-at.bofh.it> <9Mmra-56f-29@gated-at.bofh.it> <E1JFEwb-0000zs-2q@be1.7eggert.dyndns.org>
In-Reply-To: <E1JFEwb-0000zs-2q@be1.7eggert.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> 
> BTW1: These addresses may be used to detect ports on non-standard addresses,
> but unfortunately they don't tell the IRQ.
> 
> BTW2: When I submitted a patch using the BIOS data area, I was told that it
> might not exist on systems booting from non-PC firmware. This claim was not
> yet backed with any knowledge, nor did anybody suggest a way to detect this
> situation.
> 

This is, of course, true.  It doesn't exactly help that some (most?) 
non-PC firmware at least mimic the BIOS data area.

In this particular case, there is some minor sanity-checking that can be 
done: the values should be nonzero and aligned 8.

	-hpa
