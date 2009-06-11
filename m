Return-Path: <linux-kernel-owner+w=401wt.eu-S1763107AbZFKLeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763107AbZFKLeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762599AbZFKLd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:33:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60226 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463AbZFKLd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:33:59 -0400
Date: Thu, 11 Jun 2009 12:34:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       ibm@android.com, swetland@google.com, san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611123455.6c066db6@lxorguk.ukuu.org.uk>
In-Reply-To: <20090611103457.GG795@n2100.arm.linux.org.uk>
References: <20090610103131.GB13885@elf.ucw.cz>
	<20090610194852.GA28787@n2100.arm.linux.org.uk>
	<20090611.000219.206893038.davem@davemloft.net>
	<20090611073740.GB8592@elf.ucw.cz>
	<20090611103457.GG795@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now, ask yourself this question: why should I have to be the one to
> review things like ARM <-> DSP communication channel code?  Hint: I

Because you claim to be ARM maintainer and you force all the ARM stuff to
go via you ? 

We have the -next tree these days so if you cut ARM back to common core
shared ARM code and all the platform people had their own maintainer (at
least those who are competent to do so which is a fair share of them)
then you could resolve any collisions in -next. There will probably be a
few explosions on the way because code developed under such a tight
control model tends to have poor separation in places nobody thought
about but they'll fix pretty fast.

If you don't want to be reviewing some of the stuff then restructure
things so that they don't go through you and you are not the gatekeeper
for them.

Alan
