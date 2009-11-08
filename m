Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZKHXe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZKHXe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 18:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZKHXe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 18:34:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37480 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZKHXe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 18:34:58 -0500
Date: Sun, 8 Nov 2009 23:34:44 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Leo Chen <leochen@broadcom.com>
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
Message-ID: <20091108233444.GC31433@flint.arm.linux.org.uk>
References: <m14op5jjo4.fsf@fess.ebiederm.org> <1257682930-31401-22-git-send-email-ebiederm@xmission.com> <20091108123422.GA9145@flint.arm.linux.org.uk> <m1pr7siqjz.fsf@fess.ebiederm.org> <20091108225652.GB31433@flint.arm.linux.org.uk> <m1ocnch9v8.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ocnch9v8.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 03:31:23PM -0800, Eric W. Biederman wrote:
> There is not a user visible ABI change.  Just a massive implementation change.
> The only user visible change is that CONFIG_SYS_SYSCALL now depends on
> CONFIG_PROC_SYSCTL.
> 
> The implementation of sys_sysctl in binary_sysctl.c will now read
> /proc/sys/bus/isa/portbase and using vfs_read convert the text string
> to a binary integer and return it to glibc in the form sys_sysctl has
> always used.

Right, that information was missing from the original patch.  No problem
then.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
