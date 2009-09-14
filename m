Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZINAVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZINAVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 20:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbZINAU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 20:20:57 -0400
Received: from mail2.shareable.org ([80.68.89.115]:54327 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbZINAU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 20:20:57 -0400
Date: Mon, 14 Sep 2009 01:21:00 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Marek Vasut <marek.vasut@gmail.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
Message-ID: <20090914002100.GD30621@shareable.org>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com> <200909132328.47079.marek.vasut@gmail.com> <20090913230008.GC30169@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090913230008.GC30169@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Sun, Sep 13, 2009 at 11:28:47PM +0200, Marek Vasut wrote:
> > >  		bhi	__delay
> > >  		mov	pc, lr
> > >  ENDPROC(__udelay)
> > > 
> > Hi
> > 
> > why was this code there in the first place ?
> 
> To make the delay loop more stable and predictable on older CPUs.

So why has it been commented out, if it's needed for that?

-- Jamie
