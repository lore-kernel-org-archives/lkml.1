Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbYBEQZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbYBEQZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYBEQY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:24:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:53505 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbYBEQYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:24:55 -0500
Date: Tue, 5 Feb 2008 10:23:14 -0600
From: Matt Porter <mporter@kernel.crashing.org>
To: Zhang Wei <Wei.Zhang@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/6] Add multi mport support.
Message-ID: <20080205162314.GA20177@gate.crashing.org>
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <12016890621727-git-send-email-wei.zhang@freescale.com> <120168907160-git-send-email-wei.zhang@freescale.com> <12016890773706-git-send-email-wei.zhang@freescale.com> <AF4B8466-C1CE-4FFB-8341-4BFC1CB76116@kernel.crashing.org> <ABF87B0B6A38C0458E319AC973ED68AEBD0677@zch01exm26.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ABF87B0B6A38C0458E319AC973ED68AEBD0677@zch01exm26.fsl.freescale.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 01:57:25PM +0800, Zhang Wei wrote:
>  
> 
> > -----Original Message-----
> > From: Kumar Gala [mailto:galak@kernel.crashing.org] 
> > 
> > On Jan 30, 2008, at 4:30 AM, Zhang Wei wrote:
> > 
> > > Change lots of static variable to mport private. And add 
> > mport to some
> > > function declaration.
> > 
> > Can you explain this patch further.  Its not clear exactly from this  
> > commit message why we are doing this.
> > 
> > - k
> 
> Sorry about I have a little hurry about it.
> 
> The original RapidIO driver suppose there is only one mpc85xx RIO
> controller
> in system. So, some data structures are defined as mpc85xx_rio global,
> such as 'regs_win', 'dbell_ring', 'msg_tx_ring'. Now, I changed them to
> mport's private members. And you can define multi RIO OF-nodes in dts
> file
> for multi RapidIO controller in one processor, such as PCI/PCI-Ex host
> controllers
> in Freescale's silicon. And the mport operation function declaration
> should be changed
> to know which RapidIO controller is target.

Right, the RapidIO subsystem itself has had the concept of multiple
master ports from the beginning. However, when I did the MPC85xx
support I chose to just implement it for the known silicon available
at the time. I'm not surprised there's new silicon with multiple
controllers now.

-Matt
