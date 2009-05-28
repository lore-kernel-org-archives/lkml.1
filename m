Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbZE1MtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbZE1MtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762106AbZE1MtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:49:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54233 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762032AbZE1MtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:49:01 -0400
Date: Thu, 28 May 2009 14:48:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090528124853.GC1421@ucw.cz>
References: <200905221139.26941.lkml@morethan.org> <20090522183622.GA8385@elte.hu> <4A16F62B.40207@zytor.com> <200905221721.08495.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905221721.08495.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The observation that executing an unnecessary 'lock' opcode in some
> cases slows down the machine is not felt by myself to be significant 
> to duplicating my observations.  Note: I have been wrong before.
> 
> This is as informative as I can make the message.
> 
> PS: *not* a single machine failure, tested on five machines, owned
> by four different people, two brands, with different use histories.

I have seen some problems on via c7m based machines, where some 'smart
bios person' implemented EC access in AML (normally, it is accessed
from ec.c driver). Maybe you have similary bad bios?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
