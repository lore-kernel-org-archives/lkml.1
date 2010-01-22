Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863Ab0AVT2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0AVT2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 14:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734Ab0AVT2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 14:28:35 -0500
Received: from mail.perches.com ([173.55.12.10]:1424 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0AVT2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 14:28:34 -0500
Subject: Re: [PATCH 24/38] move round_up/down to kernel.h
From: Joe Perches <joe@perches.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1001220851210.2704@router.home>
References: <1264152287-13866-1-git-send-email-yinghai@kernel.org>
	 <1264152287-13866-25-git-send-email-yinghai@kernel.org>
	 <alpine.DEB.2.00.1001220851210.2704@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 11:28:32 -0800
Message-ID: <1264188512.32383.118.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 08:52 -0600, Christoph Lameter wrote:
> On Fri, 22 Jan 2010, Yinghai Lu wrote:
> > +#define __round_mask(x,y) ((__typeof__(x))((y)-1))
> > +#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
> > +#define round_down(x,y) ((x) & ~__round_mask(x,y))
> s/round/round_power2/

s/round/round_power_of_2/
BUILD_BUG_ON_NOT_POWER_OF_2



