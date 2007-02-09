Return-Path: <linux-kernel-owner+w=401wt.eu-S1423291AbXBIWGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423291AbXBIWGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423270AbXBIWGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:06:32 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3079 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423291AbXBIWGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:06:31 -0500
Date: Fri, 9 Feb 2007 22:06:24 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070209220624.GC16158@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Alexey Dobriyan <adobriyan@openvz.org>,
	linux-kernel@vger.kernel.org, drepper@redhat.com
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <1171042535.29713.96.camel@pmac.infradead.org> <20070209134516.2367a7aa.akpm@linux-foundation.org> <20070209214944.GA16158@flint.arm.linux.org.uk> <20070209140049.9e1e8463.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070209140049.9e1e8463.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 02:00:49PM -0800, Andrew Morton wrote:
> +asmlinkage long sys_lio_submit(aio_context_t ctx_id, int mode, long nr,
> +	struct iocb __user * __user *iocbpp, struct sigevent __user *event)

Not a problem.  (r0 := ctx_id, r1 := mode, r2 := nr, r3 := iocbpp,
r4 := event)  Thanks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
