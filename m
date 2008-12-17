Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758135AbYLQLfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbYLQLfI (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYLQLez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:34:55 -0500
Received: from cs20.apochromatic.org ([204.152.189.161]:52507 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYLQLey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:34:54 -0500
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Dec 2008 06:34:54 EST
Date: Wed, 17 Dec 2008 11:26:25 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Willy Tarreau <w@1wt.eu>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, mingo@elte.hu, venkatesh.pallipadi@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 68/83] x86: HPET: convert WARN_ON to WARN_ON_ONCE
Message-ID: <20081217112625.GJ13247@console-pimps.org>
References: <20081211190201.612240183@mini.kroah.org> <20081211191620.GP5894@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211191620.GP5894@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 11:16:20AM -0800, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Matt Fleming <mjf@gentoo.org>
> 
> commit 1de5b0854623d30d01d72cd4ea323eb5f39d1f16 upstream.
> 
> It is possible to flood the console with call traces if the WARN_ON
> condition is true because of the frequency with which this function is
> called.
> 

If this commit is going into stable it would be worth adding these
two commits (which are actually the bugfixes).

5ceb1a04187553e08c6ab60d30cee7c454ee139a
x86: HPET: enter hpet_interrupt_handler with interrupts disabled

89d77a1eb60be916d85d9394bedbfa2037af89c5
x86: HPET: read from HPET_Tn_CMP() not HPET_T0_CMP

