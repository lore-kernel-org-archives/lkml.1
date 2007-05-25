Return-Path: <linux-kernel-owner+w=401wt.eu-S1765387AbXEYU3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765387AbXEYU3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbXEYU3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:29:05 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3952 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765202AbXEYU3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:29:04 -0400
Date: Fri, 25 May 2007 21:28:54 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: double exclamation (!!) suckage in the kernel
Message-ID: <20070525202854.GA24801@flint.arm.linux.org.uk>
Mail-Followup-To: Satyam Sharma <satyam.sharma@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 01:53:59AM +0530, Satyam Sharma wrote:
> Are all these occurrences merely the debris of
> s/something/!notsomething/g kind of patches or is there some
> dark, unknown C / gcc wizardry I have absolutely no clue of?

Try building and running this:

#include <stdio.h>
int main()
{
	int i;
	for (i = 0; i < 10; i++)
		printf("%d: %d\n", i, !!i);
	return 0;
}

and you should see it's effect.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
