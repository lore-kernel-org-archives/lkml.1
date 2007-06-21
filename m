Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbXFURfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbXFURfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758545AbXFURer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:34:47 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:54538 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758405AbXFUReq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:34:46 -0400
Date: Thu, 21 Jun 2007 19:34:45 +0200
From: Alexander Wuerstlein <snalwuer@cip.informatik.uni-erlangen.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Alexander Wuerstlein <arw@arw.name>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signed binaries support [0/4]
Message-ID: <20070621173445.GF9741@cip.informatik.uni-erlangen.de>
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de> <20070621161758.GP12950@stusta.de> <20070621162917.GB9741@cip.informatik.uni-erlangen.de> <20070621172344.GQ12950@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621172344.GQ12950@stusta.de>
X-Echelon-Scan: plutonium bomb dirty irak allah satan bush victory c4
	cocaine saddam wtc holy war believe god cia nsa
X-Echelon-Result: Terrorist
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 070621 19:26, Adrian Bunk <bunk@stusta.de> wrote:
> On Thu, Jun 21, 2007 at 06:29:17PM +0200, Alexander Wuerstlein wrote:
> > On 070621 18:19, Adrian Bunk <bunk@stusta.de> wrote:
> > > On Thu, Jun 21, 2007 at 05:55:16PM +0200, Johannes Schlumberger wrote:
> > > 
> > > > Hi,
> > > 
> > > Hi Johannes,
> > > 
> > > > We (two students of CS) built a system for signing binaries and verifying them
> > > > before executing. Our main focus was to implement a way to inhibit execution
> > > > of suid-binaries, which are not trustworthy (i.e. not signed).
> > > >...
> > > 
> > > doesn't anyone who is able to install a not trustworthy suid-binary 
> > > already have the priviliges to do anything he wants to without requiring 
> > > an suid bit?
> > 
> > Yes, quite correct in most cases. But if you have taken control of a computer
> > on of the more common ways to keep the control for some time is the
> > installation of a suid-binary (e.g. as part of a rootkit). 
> 
> There are so many ways for manipulating a computer that controlling 
> setuid binaries hardly brings a real security gain.

Even if it does not really improve security too much it can be helpful as a
part of a larger system. For example around here we use a 'sbit-checker' that
basically does a 'find' and 'chmod', which we would be able to replace by this
patch.

Also our patch is not solely about suid-binaries, we just implemented
suid-checking because it seemed a simple and obvious thing to do.  Our real aim
was to implement binary signatures, which can be used in numerous security
related checks around the kernel. Btw. if you have any good ideas where one
could use them, please tell us :)



Ciao,

Alexander Wuerstlein.
