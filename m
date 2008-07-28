Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbYG1V4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbYG1V4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758986AbYG1Vzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:55:52 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35626 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758735AbYG1Vzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:55:52 -0400
Subject: Re: sched-powersave causes oops on 2.6.26-08037-g8cd362a
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1217281739.7345.8.camel@nimitz>
References: <1217281739.7345.8.camel@nimitz>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 14:55:49 -0700
Message-Id: <1217282149.7345.9.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 14:49 -0700, Dave Hansen wrote:
> This oops just happens on startup for me.
> 
> $ uname -a
> Linux nimitz 2.6.26-08037-g8cd362a #69 SMP Mon Jul 28 14:12:00 PDT 2008 i686 GNU/Linux
> 
> $ addr2line -e vmlinux c0126866
> linux-2.6.git/kernel/sched.c:7660
> 
> static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
> {
>         int ret;
> 
> HERE--> if (buf[0] != '0' && buf[0] != '1')
>                 return -EINVAL;

OK, I just found Andi's patch to fix this.  Have you sent it to Linus,
yet?

-- Dave

