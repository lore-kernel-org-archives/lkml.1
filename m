Return-Path: <linux-kernel-owner+w=401wt.eu-S966732AbXHGVl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966732AbXHGVl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965664AbXHGVS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:18:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45832 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965756AbXHGVSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:18:54 -0400
Message-ID: <46B8E1B8.6000201@garzik.org>
Date: Tue, 07 Aug 2007 17:18:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] net: smc91x: Build fixes for general sh boards.
References: <20070801064855.GA8118@linux-sh.org>
In-Reply-To: <20070801064855.GA8118@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> SH boards in general only wire this up in 8 or 16-bit mode, and
> as we never had the wrappers for 32-bit mode defined, SMC_CAN_USE_32BIT
> caused build failure for the non-Solution Engine boards. This gets it
> building again.
> 
> Also kill off the straggling set_irq_type() definition, this is left
> over cruft that was missed when the rest of it switched to IRQ flags.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

applied to #upstream-fixes


