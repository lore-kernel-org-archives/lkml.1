Return-Path: <linux-kernel-owner+w=401wt.eu-S932240Ab0ANXqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0ANXqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667Ab0ANXqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:46:31 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48598 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab0ANXqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:46:30 -0500
Date: Fri, 15 Jan 2010 08:46:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au, x86@kernel.org, mingo@redhat.com,
       tglx@linutronix.de, monstr@monstr.eu, hpa@zytor.com
Subject: Re: [PATCH] cpuinfo_op: consolidate extern declaration
Message-ID: <20100114234625.GD25018@linux-sh.org>
References: <201001141158.09795.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001141158.09795.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 11:58:09AM -0700, H Hartley Sweeten wrote:
> cpuinfo_op: consolidate extern declaration
> 
> All the architectures supported by the kernel also support
> /proc/cpuinfo. Only a couple actually declare the seq_operations
> as extern. All the others will produce a sparse warning like:
> 
> warning: symbol 'cpuinfo_op' was not declared. Should it be static?
> 
> Fix all the warnings and consolidate the declaration by putting it
> in <linux/seq_file.h>.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> 
I guess we know from this list which architectures run sparse ;-)

Acked-by: Paul Mundt <lethal@linux-sh.org>
