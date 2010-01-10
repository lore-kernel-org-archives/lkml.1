Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616Ab0AJOLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0AJOLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548Ab0AJOLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:11:20 -0500
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:42654 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab0AJOLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:11:18 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>, Christian Kujau <lists@nerdbynature.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100110134951.GD5189@lenovo>
References: <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de>
	 <20100106112133.GA5815@lenovo>
	 <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de>
	 <4B4633D3.2070903@zytor.com>
	 <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de>
	 <20100108215039.GD4967@lenovo>
	 <73c1f2161001091750y67a852dfk7539021dcc82fa1f@mail.gmail.com>
	 <20100110080940.GB5189@lenovo>
	 <1263128343.2393.45.camel@cthulhu.hellion.org.uk>
	 <20100110133628.GC5189@lenovo>  <20100110134951.GD5189@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jan 2010 14:05:35 +0000
Message-ID: <1263132335.2393.76.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
 tables
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=ZtHxNT4mZm3rCuM0SmWmgWxeBwJsziC8EqOrwwVkrhA= c=1 sm=0 a=WUDd807v63sA:10 a=xlfWhAX3Eg0glsqPx74A:9 a=Gy3MnjYINFGRZM2Mtfao51vlR_YA:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-10 at 16:49 +0300, Cyrill Gorcunov wrote:
> On Sun, Jan 10, 2010 at 04:36:28PM +0300, Cyrill Gorcunov wrote:
> ...
> > > 
> > > With just the CS RPL fix below I see a GPF at kernel_thread_helper with
> > > SS=3 (hence my hypothesis about NULL selectors and non-zero RPL above).
> > > With both the SS and CS fixes things work fine.
> > 
> > any of CS,SS loaded with NULL descriptor should lead to #GP
> > 
> 
> though SS with RPL=0 is allowed to be NULL descriptor in 64bit mode

yes, that's what I meant.

Ian.

-- 
Ian Campbell

Tussman's Law:
	Nothing is as inevitable as a mistake whose time has come.

