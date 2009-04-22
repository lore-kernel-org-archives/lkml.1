Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZDVIK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZDVIK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755768AbZDVIKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:10:17 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:54899 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692AbZDVIKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:10:15 -0400
Date: Wed, 22 Apr 2009 10:10:04 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc2 to -rc1 regression on arm
Message-ID: <20090422081004.GC8541@buzzloop.caiaq.de>
References: <20090422075817.GA10992@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422075817.GA10992@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 09:58:17AM +0200, Pavel Machek wrote:
> ...it now fails to compile in arch/arm/kernel/sys_oabi-compat.c ,
> complaining about missing prototypes for kmalloc/kfree.
> 
> I guess it should be easy to fix.

It _was_ easy to fix, yes:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=cbb55092a674bcfd9774637a06d0f1511763aa2c                                                               

