Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbZGNBsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbZGNBsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 21:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZGNBsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 21:48:11 -0400
Received: from fifo99.com ([67.223.236.141]:37688 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbZGNBsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 21:48:11 -0400
Subject: Re: HTC: touchscreen driver
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090713220726.GA28375@elf.ucw.cz>
References: <20090710084323.GA6522@elf.ucw.cz>
	 <a55d774e0907100155m25366994pe9ec5d0f5f868818@mail.gmail.com>
	 <20090710103243.GB7789@elf.ucw.cz>
	 <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com>
	 <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz>
	 <20090713220726.GA28375@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 18:48:07 -0700
Message-Id: <1247536087.31854.39.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 00:07 +0200, Pavel Machek wrote:
> On Mon 2009-07-13 22:57:49, Pavel Machek wrote:
> > Hi!
> > 
> > I'm looking at synaptic touchscreen driver... who should be listed as
> > an author?
> > 
> > Changes I have so far are...
> > 
> > checkpatch only has minor complains -- lines over 80 characters -- but
> > the code is _way_ too deeply nested with way too little functions.
> 
> Here's better cleanup. But... some functions are still _way_ too big.
> 

I'd put the nesting removal into another patch .. It makes reviewing
more clear, your first patch was already fairly busy .. It would also
make a bisect more fine grained if it lands on one of your patches.

Daniel

