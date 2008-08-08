Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbYHHGKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbYHHGKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYHHGK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:10:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:48278 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbYHHGK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:10:28 -0400
Subject: Re: [GIT PULL]: firmware patches for building firmware into kernel
From: Jaswinder Singh <jaswinder@infradead.org>
To: David Dillow <dave@thedillows.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1218169537.17642.40.camel@obelisk.thedillows.org>
References: <1218128219.14483.7.camel@jaswinder.satnam>
	 <1218130222.18118.7.camel@lap75545.ornl.gov>
	 <1218130475.14483.16.camel@jaswinder.satnam>
	 <1218133288.18118.20.camel@lap75545.ornl.gov>
	 <1218159490.2553.13.camel@jaswinder.satnam>
	 <1218164391.17642.14.camel@obelisk.thedillows.org>
	 <1218166760.2540.18.camel@jaswinder.satnam>
	 <1218169537.17642.40.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset=utf8
Date: Fri, 08 Aug 2008 11:38:46 +0530
Message-Id: <1218175726.13359.3.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

On Fri, 2008-08-08 at 00:25 -0400, David Dillow wrote:
> On Fri, 2008-08-08 at 09:09 +0530, Jaswinder Singh wrote:
> > On Thu, 2008-08-07 at 22:59 -0400, David Dillow wrote:
> > > I don't like releasing the firmware before the pci_unregister_driver()
> > > call. I worry about ordering issues during cleanup, though I'll admit I
> > > have not yet researched if it will be a problem. In any event, if you're
> > > going to request it once per adapter in typhoon_init_one(), then it
> > > should be in the per-device struct, and released in
> > > typhoon_remove_one().
> >
> > Here is updated patch :
> 
> You've fixed one part of the issues I described, but I think you've left
> open the possibility of dangling pointers when one card in a multi NIC
> system fails to come up. Again, I need to track down the code to see if
> I'm all wet or not.
> 

That's why I introduced firmware_release_all() for buggy drivers.

I think ﻿firmware_release_all() is best for you case.

Thank you,

Jaswinder Singh.

