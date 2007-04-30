Return-Path: <linux-kernel-owner+w=401wt.eu-S1946138AbXD3XsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946138AbXD3XsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946130AbXD3XsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:48:16 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:16172 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946138AbXD3XsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:48:15 -0400
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of
	CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
From: Daniel Walker <dwalker@mvista.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <46367D7E.6060502@rtr.ca>
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>
	 <463653A3.5040606@rtr.ca>  <46367D7E.6060502@rtr.ca>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 16:46:38 -0700
Message-Id: <1177976798.12796.286.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 19:36 -0400, Mark Lord wrote:
> Mark Lord wrote:
> > Mark Lord wrote:
> >> Mark Lord wrote:
> >>> I have a new notebook (Dell Inspiron 9400) with Core2-Duo T7400 @ 
> >>> 2.1Ghz.
> >>> When either/both of CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS is used,
> >>> the 2.6.21 kernel hangs on startup just after printing one/both of 
> >>> these:
> >> ..
> >>
> >> That's a hard hang, by the way.  No magic sysrq key or anything.
> 
> Well, in case this helps.  If I take the exact same .config that fails,
> and add *only* this to it, it then boots just fine. 
> 
>    CONFIG_DETECT_SOFTLOCKUP=y
> 
> Thomas G., are you there??

Hmm, Do you have a boot log ? I didn't see one in any of the last
emails.

Daniel

