Return-Path: <linux-kernel-owner+w=401wt.eu-S1762176AbXFBXWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762176AbXFBXWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 19:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762266AbXFBXWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 19:22:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40031 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761892AbXFBXWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 19:22:41 -0400
Subject: Re: Device Driver Etiquette
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Fredrickson <creslin@digium.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <a714c0e137cf5cf814e790e3fdef23c8@digium.com>
References: <a714c0e137cf5cf814e790e3fdef23c8@digium.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 02 Jun 2007 16:22:00 -0700
Message-Id: <1180826520.2815.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 12:47 -0500, Matthew Fredrickson wrote:

> My question is this: is there a way to either work around the problem I 
> am seeing with the stack without recompiling the kernel with 8K stack 
> size or without disabling irqs for such a long period of time (which I 
> think is not a nice thing to do either) OR is it acceptable (although 
> not nice) to simply fix it this way, by disabling irqs while it loads 
> the firmware?

I wonder if you're chasing ghosts; 4K stack kernels have a seperate
stack for interrupts so... those should be safe.

Btw, you forgot to post a pointer to the source code of your driver, so
it's a lot harder for us (read: impossible) to give you good advice..

Greetings,
   Arjan van de Ven
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

