Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbYIEKbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbYIEKbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYIEKbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:31:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51292 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYIEKbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:31:04 -0400
Date: Fri, 5 Sep 2008 11:25:33 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Khem Raj <raj.khem@gmail.com>
Subject: Re: [PATCH 02/23] arm: use the new byteorder headers
Message-ID: <20080905102533.GA26458@flint.arm.linux.org.uk>
References: <1219106875.17033.55.camel@brick> <20080819072715.GB30521@flint.arm.linux.org.uk> <1219172580.17033.87.camel@brick> <1220608169.2985.305.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220608169.2985.305.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 10:49:29AM +0100, David Woodhouse wrote:
> On Tue, 2008-08-19 at 12:03 -0700, Harvey Harrison wrote:
> > include/linux/swab.h, include/linux/byteorder.h are in current
> > mainline which is all that these patches depend on.
> 
> Er, it also depends on the patch which exports those headers to
> userspace, which isn't in Linus' tree yet.

How useful.  If those generic headers are already in Linus' tree, and
are required for architectures to convert, why hasn't the patch which
exports them to userspace already been submitted?

However, another question: why should userspace be using a kernel header
file for byteswapping?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
