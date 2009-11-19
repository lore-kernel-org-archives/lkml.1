Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZKSXkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZKSXkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 18:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbZKSXkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 18:40:07 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38376 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065AbZKSXkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 18:40:06 -0500
Date: Fri, 20 Nov 2009 08:39:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       Bryan Wu <cooloney@kernel.org>, Tony Luck <tony.luck@intel.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 2/6] cpumask: use tsk_cpumask() to access task_struct cpus_allowed.
Message-ID: <20091119233925.GA6151@linux-sh.org>
References: <200911191930.11038.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911191930.11038.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 07:30:10PM +1030, Rusty Russell wrote:
> This allows us to play with cpus_allowed.
> 
> We also take the chance to use modern cpumask_* operators on the
> lines changed.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Paul Mundt <lethal@linux-sh.org>
