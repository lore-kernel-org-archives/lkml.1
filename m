Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbXICUUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbXICUUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 16:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbXICUT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 16:19:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:40544 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbXICUTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 16:19:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rVt18+Pj2wBSMFaqoC8IrKkqi2Pm2c38moDm4mARMayOneoCPiPrUaPWIU3RUA+4fFkTWUQuM7cSJ6oQMDy+jq59IqWemZYWkFhDc7v0DG5PyMUFdb79fAFL+GXkMx4UPWqW2ox5sTWcajm8vPUnz2Ox2HhKpTqcq5QAuU6MYac=
Message-ID: <a4e6962a0709031319r63a91829v14de2ec17ac37711@mail.gmail.com>
Date: Mon, 3 Sep 2007 15:19:54 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [Lguest] [RFC] 9p Virtualization Transports
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       v9fs-developer@lists.sourceforge.net, lguest@ozlabs.org
In-Reply-To: <1188681297.10802.38.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11883271601857-git-send-email-ericvh@gmail.com>
	 <1188681297.10802.38.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tue, 2007-08-28 at 13:52 -0500, Eric Van Hensbergen wrote:
> > The lguest and kvm transports are functional, but we are still working out
> > remaining bugs and need to spend some time focusing on performance issues.
> > I wanted to send out this "preview" patch set to the community to solicit
> > ideas on things we can do differently/better.
>
>         Patches look reasonable, but just a heads-up: lguest will be moving to
> virtio, as will kvm.  That means a single implementation for both
> (yay!), but it does complicate your life in the short term 8(
>
>         Dor has published a kvm virtio implementation, and we've already
> discussed a couple of modifications.  I expect that to be nailed in the
> next 2 weeks tho, and lguest will follow.
>

yeah, I've been emailing Dor -- it sounds like he'll have stuff ready
for the 2.6.24 merge window -- that being the case, I'll write a
virtio transport and mothball the PCI and lguest transports.  They
were straightforward to write (a couple hours for the lguest
transport) and the lguest transport was a good learning experience --
so I'm not shedding tears over wasted effort.

            -eric
