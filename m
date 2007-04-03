Return-Path: <linux-kernel-owner+w=401wt.eu-S966014AbXDCRaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966014AbXDCRaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966021AbXDCRaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:30:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41011 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966014AbXDCRaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:30:11 -0400
Date: Tue, 3 Apr 2007 19:30:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
Message-ID: <20070403173010.GC23689@one.firstfloor.org>
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403182241.4b9abab6@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403182241.4b9abab6@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 06:22:41PM +0100, Alan Cox wrote:
> > benefit for the common use cases.  But as it is, the number of
> > processors is not necessarily constant over the lifetime of a process.
> > The machine architecture is.
> 
> Not once you have migration capable virtualisation it isnt.

Migration is fundamentally incompatible with many CPU optimizations.
But that's not a reason to not optimize anymore.

But I guess luckily most migration users will be able to live
with a little decreased performance after it.

-Andi
