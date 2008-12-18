Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752406AbYLRFrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbYLRFrm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 00:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYLRFrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 00:47:33 -0500
Received: from colo.lackof.org ([198.49.126.79]:40197 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbYLRFrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 00:47:32 -0500
Date: Wed, 17 Dec 2008 22:47:19 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
        Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: MSI messages
Message-ID: <20081218054719.GA10633@colo.lackof.org>
References: <49438290.1080502@gmail.com> <20081214081210.GC13371@colo.lackof.org> <49460249.8020801@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49460249.8020801@jp.fujitsu.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 04:07:53PM +0900, Kenji Kaneshige wrote:
> Grant Grundler wrote:
> >> To put it short: i am wondering how i should read the MSI messages.
> > 
> > The "message" is actually mapped to an the interrupt vector by the core
> > generic interrupt handling code in the kernel.
> > 
> > A "GSI" (Generic Sys Interrupt?) is associated with each entry in
> > the MSI-X table. Driver then calls request_irq() to bind an interrupt
> > handler to each GSI. So the driver never directly sees the "message".
> > 
> 
> I think "GSI (Global System Interrupt)" is for identifying the I/O
> APIC pin among multiple I/O APICs. Maybe you wanted to mean the
> interrupt number managed by kernel (frequently called "IRQ")?

I thought "GSI" and "kernel interrupt number" are equivalents.
But I could easily be confusing the terms here. If "GSI" is only
used for identifying APIC input lines, then that's not right term.

> Or am I misunderstanding something?

You probably understand it better than I do. :)

thanks,
grant
