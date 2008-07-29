Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYG2XWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYG2XWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYG2XV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:21:59 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:36826 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbYG2XV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:21:58 -0400
Date: Tue, 29 Jul 2008 16:21:56 -0700 (PDT)
From: Eli Collins <ecollins@vmware.com>
X-X-Sender: ecollins@ecollins-dev1.eng.vmware.com
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: petr@vmware.com, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: please revert commit 53f1b1433da7eac2607a4a0898a221a4485fd732
 (rtc: push the BKL down into the driver ioctl method)
In-Reply-To: <b6a2187b0807251918w2b2b3810h6c90df28a3261c7f@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0807281045540.4136@ecollins-dev1.eng.vmware.com>
References: <b6a2187b0807250726n77a0cd6eqb97b817fddc343b9@mail.gmail.com>  <4889F78B.9090202@zytor.com> <b6a2187b0807251918w2b2b3810h6c90df28a3261c7f@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Jul 2008, Jeff Chua wrote:

> On Fri, Jul 25, 2008 at 11:55 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > Jeff Chua wrote:
> >>
> >> This commit is breaking vmware-6.0.4. Upon booting linux (guest) on
> >> vmware, the whole vmware environment crashed.
> >
> > Quality hypervisor we have there...
> >
> >        -hpa
> >
> 
> Well then, lets hope Vmware will do something to fix this and remove
> the init_mm stuff.

The module fixes for 2.6.26+ kernels are in upcoming releases and should 
get backported to older ones.

Thanks,
Eli

