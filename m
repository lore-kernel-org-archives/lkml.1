Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbXK1MlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbXK1MlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbXK1MlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:41:09 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:44195 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752069AbXK1MlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:41:07 -0500
Message-ID: <474D61CF.6080400@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2007 18:10:47 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc3-mm2 - Build Failure on powerpc timerfd() undeclared
References: <20071128034140.648383f0.akpm@linux-foundation.org>
In-Reply-To: <20071128034140.648383f0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Kernel build fails, with build error

  CC      arch/powerpc/platforms/cell/spu_callbacks.o
In file included from arch/powerpc/platforms/cell/spu_callbacks.c:49:
include/asm/systbl.h:312: error: ‘sys_timerfd’ undeclared here (not in a function)
make[2]: *** [arch/powerpc/platforms/cell/spu_callbacks.o] Error 1
make[1]: *** [arch/powerpc/platforms/cell] Error 2
make: *** [arch/powerpc/platforms] Error 2

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
