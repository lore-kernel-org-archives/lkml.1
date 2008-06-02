Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbYFBSK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbYFBSK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYFBSKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:10:53 -0400
Received: from mail.suse.de ([195.135.220.2]:49045 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYFBSKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:10:52 -0400
Date: Mon, 2 Jun 2008 11:10:35 -0700
From: Brandon Philips <bphilips@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Bastien Nocera <bnocera@redhat.com>
Subject: Re: v4l regression: V4L2_CID_[VH]CENTER disappeared without notice.
Message-ID: <20080602181035.GA440@plankton.ifup.org>
References: <200804241931.m3OJVQiR022368@hera.kernel.org> <1212421611.16924.246.camel@pmac.infradead.org> <20080602165649.01c2c680@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602165649.01c2c680@core>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:56 Mon 02 Jun 2008, Alan Cox wrote:
> > Please can we revert the addition of _DEPRECATED to these ioctl
> > definitions. Perhaps we can add a runtime warning if they actually get
> > used? Or a compile-time warning if we can manage that?
> 
> Can you clarify the problem here ? Is this compile breakage as it appears
> (See 'do not include kernel headers in user space apps') or runtime ?

It is compile breakage and was also discussed on
fedora-devel-list@redhat.com with Mauro and myself CC'd.  The control
number will be reserved forever to avoid binary breakage.

However, as Mauro noted in that conversation: "Those controls haven't
been used by any Kernel drivers for a long time (I suspect that they
were never used)."  Since no driver had ever implemented the control I
figured user space application wouldn't be using it either.

If David wants to revert the _DEPRECATED tags that is fine; we can add a
feature removal for a year from now if it gets merged.

Thanks,

	Brandon
