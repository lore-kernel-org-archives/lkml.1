Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbXK1LDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbXK1LDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 06:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbXK1LDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 06:03:21 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:3600 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbXK1LDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:03:20 -0500
Subject: Re: [s390] build failure
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <200711281127.30051.elendil@planet.nl>
References: <200711281127.30051.elendil@planet.nl>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 28 Nov 2007 12:03:18 +0100
Message-Id: <1196247798.15829.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-28 at 11:27 +0100, Frans Pop wrote:
> $ git describe
> v2.6.24-rc3-342-g8c27eba
> 
> arch/s390/kernel/built-in.o: In function `cleanup_io_leave_insn':
> diag.c:(.text+0xc29a): undefined reference to `preempt_schedule_irq'
> make[2]: *** [.tmp_vmlinux1] Error 1

This is fixes by a patch from Christian:
      [S390] Fix compile error on 31bit without preemption

You can get the latest s390 patches by pulling from
	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git fixes

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


