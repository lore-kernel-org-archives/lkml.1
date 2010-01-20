Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984Ab0ATKBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab0ATKBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 05:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935Ab0ATKA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 05:00:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45004 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab0ATKA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 05:00:59 -0500
Date: Wed, 20 Jan 2010 10:00:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org,
       Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: git pre-commit hook running checkpatch.pl
Message-ID: <20100120100040.GB20302@n2100.arm.linux.org.uk>
References: <20100120020202.GE26562@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120020202.GE26562@trinity.fluff.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 02:02:02AM +0000, Ben Dooks wrote:
> I've written a git pre-commit[1] hook which stops any commits happening if
> checkpatch.pl reports problems with the patch. Any comments?

Very bad - checkpatch can be wrong at times.

Eg 1, asm/irq.h vs linux/irq.h
Eg 2, asm/memory.h vs linux/memory.h
Eg 3, lines longer than 80 characters for printk() strings are preferred
  so that they are grep-able.

checkpatch is at best a guide, not a set of hard rules.
