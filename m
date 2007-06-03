Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXFCPsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXFCPsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 11:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXFCPsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 11:48:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38314 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbXFCPsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 11:48:07 -0400
Message-ID: <4662E2AC.8050004@garzik.org>
Date: Sun, 03 Jun 2007 11:47:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jeff@garzik.org>,
       Nobuhiro Iwamatsu <iwamatsu@nigauri.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smc91x: sh solution engine fixes.
References: <20070601083648.GA11035@linux-sh.org>
In-Reply-To: <20070601083648.GA11035@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> The current smc91x I/O routines ifdef the solution engine subtypes
> individually, which is rather bogus, as they can simply use
> CONFIG_SOLUTION_ENGINE instead. This fixes it for some of the other
> solution engines that weren't included in the ifdef list (SH7206
> specifically).
> 
> There are also inb/outb definitions which are totally bogus (missing
> brackets in _both_ cases, SMC_CAN_USE_8BIT == 0, and even better, they
> try to use a 16-bit access to fake 8-bit access). Kill that nonsense off
> completely.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

applied to #upstream-fixes


