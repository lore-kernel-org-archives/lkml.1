Return-Path: <linux-kernel-owner+w=401wt.eu-S933355AbYEFWik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355AbYEFWik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933629AbYEFWhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:37:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56744 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933626AbYEFWhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:37:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: drivers/mfd/htc-pasic3.c:22:31: error: asm/arch/pxa-regs.h: No such file or directory
Date: Wed, 7 May 2008 00:37:58 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Philipp Zabel <philipp.zabel@gmail.com>
References: <20080422074124.GA12187@elte.hu> <20080422083722.GA3609@flint.arm.linux.org.uk>
In-Reply-To: <20080422083722.GA3609@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805070037.59263.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 22 of April 2008, Russell King wrote:
> On Tue, Apr 22, 2008 at 09:41:24AM +0200, Ingo Molnar wrote:
> > 
> > make allyesconfig (on 64-bit x86) build fails on latest -git with the 
> > following message:
> > 
> > drivers/mfd/htc-pasic3.c:22:31: error: asm/arch/pxa-regs.h: No such file or directory
> > 
> > i suspect this driver was not supposed to be buildable on non-ARM-PXA? 
> > The patch below should fix this.
> 
> Known issue.  Thanks.

Has it been fixed in the mainline?

Rafael
