Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbYDVQzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbYDVQzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbYDVQyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:54:51 -0400
Received: from NaN.false.org ([208.75.86.248]:44261 "EHLO nan.false.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbYDVQyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:54:50 -0400
X-Greylist: delayed 1864 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2008 12:54:50 EDT
Date: Tue, 22 Apr 2008 12:23:43 -0400
From: Daniel Jacobowitz <dan@debian.org>
To: David Daney <ddaney@avtrex.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch 6/6] Ptrace support for HARDWARE_WATCHPOINTS.
Message-ID: <20080422162343.GA14790@caradoc.them.org>
Mail-Followup-To: David Daney <ddaney@avtrex.com>,
	linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
References: <480D2151.2020701@avtrex.com> <480D33EB.30808@avtrex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480D33EB.30808@avtrex.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 05:40:11PM -0700, David Daney wrote:
> +struct mips32_watch_regs {
> +	unsigned int num_valid;
> +	unsigned int reg_mask;
> +	unsigned int irw_mask;
> +	unsigned long watchlo[8];
> +	unsigned int watchhi[8];
> +};

Please do not use long in new ptrace interfaces.  Use either
uint32_t or uint64_t as appropriate so that it doesn't depend
on how the kernel or debugger was built.

-- 
Daniel Jacobowitz
CodeSourcery
