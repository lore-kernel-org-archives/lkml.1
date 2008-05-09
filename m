Return-Path: <linux-kernel-owner+w=401wt.eu-S1761245AbYEIDPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245AbYEIDPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 23:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbYEIDPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 23:15:33 -0400
Received: from ozlabs.org ([203.10.76.45]:39674 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbYEIDPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 23:15:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18467.49613.367933.672004@cargo.ozlabs.ibm.com>
Date: Fri, 9 May 2008 13:15:25 +1000
From: Paul Mackerras <paulus@samba.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.25-rc2-git4 - Regression Kernel oops  while running
 kernbench and tbench on powerpc
In-Reply-To: <4810231B.6020105@linux.vnet.ibm.com>
References: <47BC40BC.3040405@linux.vnet.ibm.com>
	<18427.11023.8067.795279@cargo.ozlabs.ibm.com>
	<47FB5C5A.5020104@linux.vnet.ibm.com>
	<18427.65299.403151.344959@cargo.ozlabs.ibm.com>
	<47FC5227.3030501@linux.vnet.ibm.com>
	<18435.11286.201115.396713@cargo.ozlabs.ibm.com>
	<48035C03.10104@linux.vnet.ibm.com>
	<18446.61538.620549.715043@cargo.ozlabs.ibm.com>
	<4810231B.6020105@linux.vnet.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal writes:

> Thanks, after applying the patch the oops is not reproducible on the machine. The console
> log had no message starting with SLB: or FWNMI:. I have updated the bugzilla also.
> 
> Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Could you test Linus' current git tree and see if you can reproduce
the same problem now?  The patch I sent upstream was a little
different from the one you tested, though it should have the same
effect, and I would like to be sure that it is just as effective at
fixing the bug.

Thanks,
Paul.
