Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbYJQOoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbYJQOoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYJQOoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:44:16 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:32601 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbYJQOoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:44:16 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: n0ano@n0ano.com
Subject: Re: [PATCH] Enable console on PCI serial devices
Date: Fri, 17 Oct 2008 08:44:01 -0600
User-Agent: KMail/1.9.9
Cc: donald.d.dugger@intel.com, linux-kernel@vger.kernel.org
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <200810161716.47620.bjorn.helgaas@hp.com> <20081017023912.GA9378@xolotl.n0ano.com>
In-Reply-To: <20081017023912.GA9378@xolotl.n0ano.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810170844.02124.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008 08:39:12 pm n0ano@n0ano.com wrote:
> On Thu, Oct 16, 2008 at 05:16:47PM -0600, Bjorn Helgaas wrote:
> >... 
> > Did you play with "console=uart,io,0xe880,115200n8" at all?
> > 
> > That gives you early serial console output and automatically switches
> > to the matching ttyS device when it is discovered.
> > 
> > "console=uart" doesn't have support for crystal frequency, but that
> > could be added in drivers/serial/8250_early.c.
> > 
> 
> Yep, that was pointed out and my latest patch does just that, use the
> `uart' syntax to specify I/O address and enhance it to control crystal
> frequency.

Oops, sorry, I forgot to read the followups before responding.
