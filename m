Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZCEMJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZCEMJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZCEMJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:09:42 -0500
Received: from www.tglx.de ([62.245.132.106]:46249 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZCEMJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:09:41 -0500
Date: Thu, 5 Mar 2009 13:09:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James.Bottomley@HansenPartnership.com, jengelh@medozas.de,
       bharrosh@panasas.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
 scsi-sgpool)objects
In-Reply-To: <20090305110736.GJ32407@elte.hu>
Message-ID: <alpine.LFD.2.00.0903051246190.3048@localhost.localdomain>
References: <20090305182958Q.fujita.tomonori@lab.ntt.co.jp> <20090305100901.GU11787@kernel.dk> <20090305101436.GV11787@kernel.dk> <20090305192737I.fujita.tomonori@lab.ntt.co.jp> <20090305103023.GW11787@kernel.dk> <20090305104159.GE32407@elte.hu>
 <20090305110534.GX11787@kernel.dk> <20090305110736.GJ32407@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

On Thu, 5 Mar 2009, Ingo Molnar wrote:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Thu, Mar 05 2009, Ingo Molnar wrote:
> It pulled without conflicts so we are good. Started testing it. 
> Once Thomas is around i suspect he'll be able to test it too 
> with his reproducer.

I started the tests on the reproducer machine and the first result
looks good so far. I let the tests run in a loop to make sure that it
fixes the problem for real. Will report later today what the long run
outcome is.

Thanks,

	tglx


