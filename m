Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbYBYW7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbYBYW7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758461AbYBYW6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:58:52 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756792AbYBYW6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:58:51 -0500
Date: Mon, 25 Feb 2008 14:57:46 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: net: tx timeouts with skge, 8139too, dmfe drivers/NICs
Message-ID: <20080225145746.6b6f336a@extreme>
In-Reply-To: <200802260009.46487.mitov@issp.bas.bg>
References: <200802252237.12326.mitov@issp.bas.bg>
	<200802252336.06498.mitov@issp.bas.bg>
	<20080225134216.7704696d@extreme>
	<200802260009.46487.mitov@issp.bas.bg>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 00:09:46 +0200
Marin Mitov <mitov@issp.bas.bg> wrote:

> Hi Stephen,
> 
> > Make sure the interrupt is showing up as level triggered in
> > /proc/interrupts. The BIOS may be configuring it as edge-triggered and that
> > won't work with Ethernet drivers that use NAPI.
> 
> for: skge <--> Marvell 88E8001 chip
> cat /proc/interrupts gives (AMD64 X2 SMP):
>            CPU0       CPU1
>  21:   11691000   11933174   IO-APIC-fasteoi   eth0
> 
> It is neither IO-APIC-edge, nor IO-APIC-level.
> 
> Could it be the problem?
> 
> Marin Mitov

No. that isn't the problem.
