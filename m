Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbYIIHOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbYIIHOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbYIIHOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:14:15 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:62761 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbYIIHOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:14:14 -0400
Date: Mon, 8 Sep 2008 17:13:56 -0700 (PDT)
From: Steven Noonan <steven@uplinklabs.net>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: fix HPET compiler error when not using
 CONFIG_PCI_MSI
In-Reply-To: <20080909065602.GB27747@elte.hu>
Message-ID: <alpine.LNX.2.00.0809081711370.5353@heimdall.uplinklabs.net>
References: <1220915951-11434-1-git-send-email-steven@uplinklabs.net> <20080909065602.GB27747@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Sep 2008, Ingo Molnar wrote:

> 
> I'm wondering, what is the compiler error you got? I havent seen any in 
> my testing.
> 
> 	Ingo
> 

Actually, it was technically a compiler warning and link error.

The compiler warning was "hpet_setup_msi_irq used but never defined", and 
then when trying to link, it threw the linker error "undefined reference 
to hpet_setup_msi_irq".

- Steven
