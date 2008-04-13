Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbYDMVha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbYDMVha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 17:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYDMVhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 17:37:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:33000 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbYDMVhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 17:37:22 -0400
Subject: Re: pci: add to global list before sysfs?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080405185501.41ec42a7@mjolnir.drzeus.cx>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx>
	 <20080404210132.GA14418@suse.de>
	 <20080405115727.1265e8a9@mjolnir.drzeus.cx>
	 <20080405155323.GA27252@suse.de>
	 <20080405185501.41ec42a7@mjolnir.drzeus.cx>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 07:37:14 +1000
Message-Id: <1208122634.6958.59.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-04-05 at 18:55 +0200, Pierre Ossman wrote:
> > Why not just create a thread in your driver, or timer, and sleep
> until
> > you see the other devices?  If after a certian time you never do,
> then
> > bail out.
> > 
> > That should work properly for you for both cases (startup and
> loading
> > later.)
> > 

You don't need a timer. You can just use the notifier mechanism I added
a while ago that should call you on device addition and removal on the
bus type you are interested in.

Ben.


