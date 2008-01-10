Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbYAJRlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbYAJRlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 12:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbYAJRlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 12:41:25 -0500
Received: from mx1.ukfsn.org ([77.75.108.10]:40945 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752750AbYAJRlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 12:41:24 -0500
Date: Thu, 10 Jan 2008 17:41:20 +0000
From: Nick Warne <nick@ukfsn.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: Driver 'sd' needs updating
Message-ID: <20080110174120.4cbde2cf@linuxamd.linicks.net>
In-Reply-To: <20080110203845E.fujita.tomonori@lab.ntt.co.jp>
References: <20080110085150.53addacf@linuxamd.linicks.net>
	<20080110203845E.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 20:38:45 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
 
> >    "Driver 'sd' needs updating - please use bus_type methods"
> > 
> > The warning never appeared in RC6, and all google reveals are other
> > peoples logs that are posted about other issues.
> > 
> > Do I need to fix up something here?
> 
> No, you don't. It's harmless, a side effect of:
> 
> commit 751bf4d7865e4ced406be93b04c7436d866d3684
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Wed Jan 2 11:14:30 2008 -0600
> 
>     [SCSI] scsi_sysfs: restore prep_fn when ULD is removed

Ah, I see.  Thanks for clarification.

Nick
-- 
Free Software Foundation Associate Member 5508
