Return-Path: <linux-kernel-owner+w=401wt.eu-S966365AbXJSDt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966365AbXJSDt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763720AbXJSDtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:49:50 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:43549 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763520AbXJSDtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:49:49 -0400
Date: Fri, 19 Oct 2007 12:49:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: linuxsh <linuxsh-dev@lists.sourceforge.net>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH / HP6XX] : Add Timer values into HD64461.h
Message-ID: <20071019034937.GA8477@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Kristoffer Ericson <kristoffer.ericson@gmail.com>,
	linuxsh <linuxsh-dev@lists.sourceforge.net>,
	linux-main <linux-kernel@vger.kernel.org>
References: <20071018213904.c0be3b03.Kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018213904.c0be3b03.Kristoffer.ericson@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 09:39:04PM -0700, Kristoffer Ericson wrote:
> This patch adds HD64461 Timer adresses & registers to the HD64461
> header file (/include/asm-sh/hd64461.h).  The timers (TMU0 & TMU1) can
> hold 16bit values and auto loads the counter constant when it reaches
> zero. Upon reaching zero it generates an interrupt.
> 
> Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> 
There's nothing that uses these, so why are you adding them? If you plan
on hooking these up in the hd64461 or TMU code, submit these definitions
along with the code that uses them.
