Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYGKKc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYGKKc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYGKKcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:32:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50841
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753180AbYGKKcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:32:43 -0400
Date: Fri, 11 Jul 2008 03:32:42 -0700 (PDT)
Message-Id: <20080711.033242.58168774.davem@davemloft.net>
To: matthew@wil.cx
Cc: ebiederm@xmission.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, grundler@parisc-linux.org, mingo@elte.hu,
       tglx@linutronix.de, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       suresh.b.siddha@intel.com, benh@kernel.crashing.org,
       jbarnes@virtuousgeek.org, rdunlap@xenotime.net, mtk.manpages@gmail.com
Subject: Re: Multiple MSI, take 3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080711102326.GR14894@parisc-linux.org>
References: <20080711005719.GO14894@parisc-linux.org>
	<m1iqvc91li.fsf@frodo.ebiederm.org>
	<20080711102326.GR14894@parisc-linux.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Date: Fri, 11 Jul 2008 04:23:26 -0600

> On Fri, Jul 11, 2008 at 03:06:33AM -0700, Eric W. Biederman wrote:
> > So unless the performance of the AHCI is better by a huge amount I don't
> > see the point, and even then I am extremely sceptical.
> 
> I don't have performance numbers yet, but surely you can see that
> avoiding a register read in the interrupt path is a large win?

Such overhead is going to be amortized.

AHCI is not like networking where we have lots of very small
transactions to deal with, and therefore the per-IRQ overhead can
begin to dominate.

Therefore, like Eric, I think workng on multiple MSI is a very dubious
usage of one's time.  But, it's your time, so use it how you wish :)
