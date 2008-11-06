Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbYKFKkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbYKFKkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYKFKkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:40:36 -0500
Received: from ozlabs.org ([203.10.76.45]:60809 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbYKFKkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:40:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18706.51381.987014.370948@cargo.ozlabs.ibm.com>
Date: Thu, 6 Nov 2008 21:36:37 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andreas Schwab <schwab@suse.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix msr check in compat_sys_swapcontext
In-Reply-To: <jey6zx9piz.fsf@sykes.suse.de>
References: <jeprlabbi6.fsf@sykes.suse.de>
	<18706.16317.759662.855430@cargo.ozlabs.ibm.com>
	<jey6zx9piz.fsf@sykes.suse.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab writes:

> Paul Mackerras <paulus@samba.org> writes:
> 
> > we need to use get_user, not __get_user, since we haven't done an
> > access_ok() check on the address.
> 
> The address is always ok since its a compat pointer, see do_setcontext.

OK, since it's inside a CONFIG_PPC64 block.  I'll add a paragraph to
the patch description pointing that out.

Paul.
