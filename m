Return-Path: <linux-kernel-owner+w=401wt.eu-S1762994AbYHESOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994AbYHESOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761044AbYHESOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:14:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40847 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbYHESOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:14:34 -0400
Date: Tue, 5 Aug 2008 11:11:41 -0700
From: Greg KH <greg@kroah.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
	interfaceforon access scanning
Message-ID: <20080805181141.GA10700@kroah.com>
References: <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

On Tue, Aug 05, 2008 at 02:04:26PM -0400, Press, Jonathan wrote:
> I'm not sure if this is off the direct idea of this thread, or if I am
> possibly missing the whole point.

I think you might be missing the point a bit here, as the traditional
Unix model that Linux has prevents much of what the "traditional AV"
products need to do, right?

> However, I want to point out that scanning on close is still an integral
> part of AV protection, even if intercepting opens and execs
> theoretically catches everything.

Great, then put a hook in glibc and catch all closes and then kick off
your scanning.

> You can say that there are four parts to the malware life cycle --
> getting on a machine, residing there, causing local damage, and
> propagating elsewhere.  It is part of the philosophy of AV protection
> that you do everything you can to prevent all of them.

But this proposed patchset does not do much to prevent all of these,
right?

> That's why there are scans on close, scheduled scans, and scans on
> open.  Most of our users employ all three and do not rely on one or
> two.  If an infection arrives on a machine and finds a home because it
> is assumed that it will be caught when it is opened for use, then it
> is just one more compromise away from doing damage and/or spreading.

So how are you going about preventing the "infection from arriving"
with this proposed patchset?

Isn't that something that SELinux or another LSM can prevent better?

thanks,

greg k-h
