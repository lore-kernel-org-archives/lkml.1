Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYADQG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYADQG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYADQGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:06:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38691 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYADQGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:06:21 -0500
Date: Fri, 4 Jan 2008 16:04:45 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben@fluff.org>,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com,
       bryan.wu@analog.com
Subject: Re: [PATCH 2/3] Rework arch specific Makefiles to use mkubootimg
Message-ID: <20080104160445.GA27269@flint.arm.linux.org.uk>
References: <20080103160104.171f9aaa@zod.rchland.ibm.com> <20080103160406.7ef5ecfe@zod.rchland.ibm.com> <20080103224139.GA4178@fluff.org.uk> <20080103165854.0d6accef@zod.rchland.ibm.com> <20080104040119.GA10268@linux-sh.org> <20080104091928.GA28547@flint.arm.linux.org.uk> <20080104103345.GA15184@linux-sh.org> <20080104054802.40325b15@zod.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104054802.40325b15@zod.rchland.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 05:48:02AM -0600, Josh Boyer wrote:
> Rework the architecture specific Makefiles to use the in-kernel version of
> the mkubootimg tool.
> 
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

>From the point of view of no overall change: Ack.

>From the point of view of whether we should have this in the kernel:
probably not.

See http://lists.arm.linux.org.uk/lurker/thread/20071203.131631.85e7a1a5.en.html#20071203.131631.85e7a1a5

for a recent discussion on the ins and outs, multiple formats, options
and so forth passed to mk(u)image.  It looks like we're heading for 5 or
6 different kernel image formats for the ARM architecture. ;(

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
