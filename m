Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811Ab0AUJCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0AUJCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 04:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742Ab0AUJCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 04:02:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:42570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab0AUJCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 04:02:14 -0500
Subject: Re: qlogic lockdep warning
From: Peter Zijlstra <peterz@infradead.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       James.Bottomley@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <7b6bb4a51001210046mdb48624xf3efc8bf756efb40@mail.gmail.com>
References: <86802c441001201710heee6a1g744f69f4edcbc52c@mail.gmail.com>
	 <1264062159.4283.1125.camel@laptop>
	 <7b6bb4a51001210046mdb48624xf3efc8bf756efb40@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 10:02:07 +0100
Message-ID: <1264064527.4283.1139.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 16:46 +0800, Xiaotian Feng wrote:
> qla24xx_msix_default is using spin_lock_irq and spin_unlock_irq within
> the irq handler...
> I think convert to spin_lock_irqsave/spin_unlock_irqrestore can solve
> this warning.

Not only that it'll actually solve a bug too ;-)

Also,

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

