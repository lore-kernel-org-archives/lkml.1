Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753137AbYLRLj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbYLRLj1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYLRLjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:39:18 -0500
Received: from www.tglx.de ([62.245.132.106]:53303 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYLRLjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:39:17 -0500
Date: Thu, 18 Dec 2008 12:37:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@suse.de>
cc: Matt Fleming <matt@console-pimps.org>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Willy Tarreau <w@1wt.eu>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mingo@elte.hu,
        venkatesh.pallipadi@intel.com
Subject: Re: [patch 68/83] x86: HPET: convert WARN_ON to WARN_ON_ONCE
In-Reply-To: <20081217184236.GC30724@suse.de>
Message-ID: <alpine.LFD.2.00.0812181235170.3492@localhost.localdomain>
References: <20081211190201.612240183@mini.kroah.org> <20081211191620.GP5894@kroah.com> <20081217112625.GJ13247@console-pimps.org> <s5h4p13dojm.wl%tiwai@suse.de> <20081217120305.GK13247@console-pimps.org> <20081217184236.GC30724@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008, Greg KH wrote:
> > Ah, thanks. I wasn't aware of that.
> 
> Ok, so which patch should go into the 2.6.27-stable tree?

Just the WARN_ON_ONCE() one: 1de5b0854623d30d01d72cd4ea323eb5f39d1f16

Thanks,

	tglx
