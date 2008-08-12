Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYHLLgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYHLLgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 07:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYHLLf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 07:35:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:37062 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbYHLLfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 07:35:55 -0400
Date: Tue, 12 Aug 2008 04:36:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [patch 1/2] fastboot: Add a module parameter to skip probing of
 specific ports
Message-ID: <20080812043603.3d8471d4@infradead.org>
In-Reply-To: <20080812083903.6d402c2e@lxorguk.ukuu.org.uk>
References: <20080811153542.61095e5c@infradead.org>
	<20080811153641.706726ec@infradead.org>
	<20080812083903.6d402c2e@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 08:39:03 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Mon, 11 Aug 2008 15:36:41 -0700
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > 
> > From: Kristen Accardi <kristen.c.accardi@intel.com>
> > Subject: [PATCH] libata: Add a module parameter to skip probing of
> > specific ports
> > 
> > Port probing by libata can easily take 10% or more of the kernel
> > boot time (2%+ of total). For cases where one knows there is nothing
> > connected to certain ports (for example on netbooks) this is a waste
> > of boot time.
> > 
> > This patch adds a module parameter that allows the admin to specify
> > to skip ports (specified by a bitmask) and recoup this boot time.
> > This capability is potentially also useful to get systems to boot
> > for cases where port-probing on a certain ports causes crashes.
> > 
> > A follow-on patch will add the capability to use DMI identification
> > to automate this for certain known systems.
> 
> What happens if I plug in an additional libata using device ?

on an eeepc ? ;)

at least for the command line option the owner (or whoever sets up
grub) knows the order and could adjust. For the DMI patch you do have a
point.

> What
> defines the probe order here particularly as people are pushing for
> parallel probing of multiple devices.

the patches I'm pushing for this don't change probe order; that has
been tried before and wasn't a great success.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
