Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbYG3It6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbYG3It6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYG3Itu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:49:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33214 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753014AbYG3Itt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:49:49 -0400
Date: Wed, 30 Jul 2008 09:32:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Cc: "Eli Collins" <ecollins@vmware.com>, petr@vmware.com,
       "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: please revert commit 53f1b1433da7eac2607a4a0898a221a4485fd732
 (rtc: push the BKL down into the driver ioctl method)
Message-ID: <20080730093216.6cbaf99c@lxorguk.ukuu.org.uk>
In-Reply-To: <b6a2187b0807291819s595685bfod3ba53b6720b4cf0@mail.gmail.com>
References: <b6a2187b0807250726n77a0cd6eqb97b817fddc343b9@mail.gmail.com>
	<4889F78B.9090202@zytor.com>
	<b6a2187b0807251918w2b2b3810h6c90df28a3261c7f@mail.gmail.com>
	<alpine.DEB.1.10.0807281045540.4136@ecollins-dev1.eng.vmware.com>
	<b6a2187b0807291819s595685bfod3ba53b6720b4cf0@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 09:19:55 +0800
"Jeff Chua" <jeff.chua.linux@gmail.com> wrote:

> On Wed, Jul 30, 2008 at 7:21 AM, Eli Collins <ecollins@vmware.com> wrote:
> 
> > The module fixes for 2.6.26+ kernels are in upcoming releases and should
> > get backported to older ones.
> 
> Thanks, just let me know when it'll be available and I'll be more than
> happy to test it out for you.
> 
> At the mean time, I've worked around the problem by adding back .ioctl
> that vmware is can work in 2.6.27-rc1.

Thanks for confirming this is the case. I'm intrigued to think that
vmware considers itself somehow an independant work when it goes poking
around the innards of private kernel structures in this way. I think this
breakage speaks volumes

Alan
