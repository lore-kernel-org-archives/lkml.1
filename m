Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZIMXAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZIMXAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 19:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZIMXAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 19:00:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43180 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZIMXAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 19:00:19 -0400
Date: Mon, 14 Sep 2009 00:00:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       Felipe Contreras <felipe.contreras@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
Message-ID: <20090913230008.GC30169@n2100.arm.linux.org.uk>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com> <200909132328.47079.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909132328.47079.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13, 2009 at 11:28:47PM +0200, Marek Vasut wrote:
> >  		bhi	__delay
> >  		mov	pc, lr
> >  ENDPROC(__udelay)
> > 
> Hi
> 
> why was this code there in the first place ?

To make the delay loop more stable and predictable on older CPUs.
