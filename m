Return-Path: <linux-kernel-owner+w=401wt.eu-S1762033AbXHEVwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033AbXHEVwB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 17:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbXHEVvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 17:51:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:50534 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980AbXHEVvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 17:51:53 -0400
Subject: Re: "Badness at kernel/irq/resend.c:70" on boot - via-pmu?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Collins <paul@briny.ondioline.org>, Ingo Molnar <mingo@elte.hu>,
       paulus@samba.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <alpine.LFD.0.999.0708042139300.5037@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
	 <87sl6ypsx2.fsf@briny.wgtn.ondioline.org>
	 <alpine.LFD.0.999.0708042139300.5037@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 07:51:44 +1000
Message-Id: <1186350704.938.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-04 at 21:41 -0700, Linus Torvalds wrote:
> 
> On Sun, 5 Aug 2007, Paul Collins wrote:
> > 
> > I got the message below on boot with 2.6.23-rc2 on my PowerBook.
> 
> It's a debug message, I think we need to remove it. It's trying to figure 
> out what goes wrong with one particular machine, and I probably shouldn't 
> have merged it for mainline.
> 
> Ignore it, it will be gone soon enough, and it should happen just once per 
> boot.

Actually, it's interesting as that irq shouldn't hit that path :-) Not
critical (won't break anything), but still something I'll look into just
in case it hides something bad.

Cheers,
Ben.


