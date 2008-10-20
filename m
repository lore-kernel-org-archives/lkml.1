Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbYJTRWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbYJTRWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYJTRLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:11:38 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:45523 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYJTRLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:11:37 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: [PATCH] Enable console on PCI serial devices
Date: Mon, 20 Oct 2008 11:11:07 -0600
User-Agent: KMail/1.9.9
Cc: n0ano@n0ano.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       donald.d.dugger@intel.com, linux-kernel@vger.kernel.org
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <20081017170638.GJ14490@xolotl.n0ano.com> <20081020164404.GE22851@csclub.uwaterloo.ca>
In-Reply-To: <20081020164404.GE22851@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201111.08703.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008 10:44:04 am Lennart Sorensen wrote:
> On Fri, Oct 17, 2008 at 11:06:38AM -0600, n0ano@n0ano.com wrote:
> > We could do that but now the `clock' value becomes a very large
> > number that is very magic.  Putting in the highest baud rate seems
> > to make more sense than some magic number.
> 
> Yeah, and isn't that usually called the base_baud or something like
> that?

It doesn't bother me that the number is large.  It's only a factor
of 16 bigger than the baud rate.  It is sort of magic, but on the
other hand, the number is often printed on a part on the board, so
it's easy to determine, and fairly easy to document.  If you've
lost the box with the marketing messages on it, I'd argue that it's
easier to determine the clock rate than the fastest baud rate.

To me it seems more confusing to specify two baud rates: the one
you want to use, and the fastest one the UART supports.

Bjorn "i want my bike shed *blue*" :-)
