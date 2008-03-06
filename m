Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbYCFPd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbYCFPd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYCFPdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:33:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51122 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbYCFPdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:33:49 -0500
Date: Thu, 6 Mar 2008 15:33:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: ye janboe <janboe.ye@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix signal return code when enable CONFIG_OABI_COMPAT
Message-ID: <20080306153337.GM3283@flint.arm.linux.org.uk>
References: <af3ea28a0803060714s523ede0cr27b12979865f6faf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3ea28a0803060714s523ede0cr27b12979865f6faf@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 11:14:50PM +0800, ye janboe wrote:
> commit b4e8bde513a9a477c30c8769073ced7b59676d48
> Author: janboe <janboe.ye@gmail.com>
> Date:   Thu Mar 6 23:00:23 2008 +0800
> 
>     fix signal return code when enable CONFIG_OABI_COMPAT.
>     because this will make kernel report this syscall obsolete.
>     Signed-off-by: Janboe Ye <janboe.ye@gmail.com>

This is all horribly broken for OABI compat anyway (because __NR_* don't
contain the right prefix).  So this patch doesn't actually fix the real
problem.
