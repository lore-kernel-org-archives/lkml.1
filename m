Return-Path: <linux-kernel-owner+w=401wt.eu-S1759760AbYEOOca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbYEOOca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYEOOcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:32:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:30090 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbYEOOcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:32:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=pCg00TXVZ2EXT/ijxbkXgd700ZEN5OfjFfC9YmA4iUE2U55dfg2d+P39lVjuxb5nXmtLwPezbvONkdv3ltxOvGspx06S4SvEHn3S1HOx9/9K2ZSYsoKTusEvVdbVWqbLDWSntL6Cql8JPofDAfPle+ZWpeQaKRDy/4HWhtgBUH8=
Message-ID: <482C4966.5090607@frugalware.org>
Date: Thu, 15 May 2008 16:32:06 +0200
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Michal Simek <Monstr@seznam.cz>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: PRINTK_TIME
References: <5284.8268-13007-901443894-1210858655@seznam.cz>
In-Reply-To: <5284.8268-13007-901443894-1210858655@seznam.cz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Gabriel C <nix.or.die@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:

> HI All,


Hi,

> 
> I had problem with non zero value when I turn on PRINTK_TIME.
> 
> Part of log. Zero value is only before sched starting.
> 
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] Self modified code enable
> [42949372.960000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
> [42949372.960000] Kernel command line: console=ttyUL0,115200
> [42949372.960000] xlnx,xps-intc-1.00.a #0 at 0x40000000, num_irq=8, edge=0x0
> 
> I think I need to set this starting value to zero.
> Could you give me a hit where the problem can be?


Known regression , see http://bugzilla.kernel.org/show_bug.cgi?id=10648

> 
> Thanks,
> Michal

Gabriel

