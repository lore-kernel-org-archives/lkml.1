Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636Ab0AUNMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0AUNMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187Ab0AUNMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:12:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:39789 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0AUNMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:12:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mLeDvV3+WIMUh6lyJG7KZ9uT360DQSXKkORKGdfIlWW3hQ9+mjy/zmp4HGe1hiwQ0t
         zram14bZHFl8t42Z4aeY9WaToaUy4t00FZ6MWR6AxxjbA4QNkdlXXEXS8ees+jIfM9Er
         Ev4rA/T+j2x94+416b7eIs1Bh68DIquQXFiRw=
Date: Thu, 21 Jan 2010 14:12:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       prasad@linux.vnet.ibm.com, maneesh@in.ibm.com
Subject: Re: [patch] HWBKPT FIX: Release the bp slot if
	arch_validate_hwbkpt_settings() fails.
Message-ID: <20100121131245.GG5017@nowhere>
References: <20100121125113.152043766@mars.in.ibm.com> <20100121125516.GA32521@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100121125516.GA32521@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 06:25:16PM +0530, Mahesh Salgaonkar wrote:
> 
> On a given architecture, when hardware breakpoint registration fails due
> to un-supported access type (read/write/execute), we loose the bp slot since
> register_perf_hw_breakpoint() does not release the bp slot on failure.
> Hence, any subsequent hardware breakpoint registration starts failing
> with 'no space left on device' error.
> 
> This patch introduces error handling in register_perf_hw_breakpoint()
> function and releases bp slot on error.
> 
> Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>


Thanks. I'm queuing it.

