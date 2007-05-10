Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbXEJFeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbXEJFeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977AbXEJFd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:33:57 -0400
Received: from ozlabs.org ([203.10.76.45]:48737 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827AbXEJFd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:33:56 -0400
Subject: Re: [PATCH 3/3] stop_machine() now uses hard_irq_disable
From: Rusty Russell <rusty@rustcorp.com.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070510052624.06AD7DDF2E@ozlabs.org>
References: <20070510052624.06AD7DDF2E@ozlabs.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 15:33:54 +1000
Message-Id: <1178775234.7286.189.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 15:25 +1000, Benjamin Herrenschmidt wrote:
> Add a call to hard_irq_disable() to stop_machine so that we make sure
> IRQs are really disabled and not only lazy-disabled on archs like
> powerpc as some users of stop_machine() may rely on that.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.


