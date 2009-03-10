Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbZCJTs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbZCJTs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 15:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbZCJTsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 15:48:32 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:41705 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbZCJTs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:48:29 -0400
X-Greylist: delayed 4328 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2009 15:48:29 EDT
Date: Tue, 10 Mar 2009 18:36:10 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch and pr_fmt()?
Message-ID: <20090310183610.GE28243@shadowen.org>
References: <Pine.LNX.4.64.0812181718250.1445@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812181718250.1445@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 05:24:06PM +0100, Geert Uytterhoeven wrote:
> When using the recently introduced pr_fmt() infrastructure (commit
> d091c2f58ba32029495a933b721e8e02fbd12caa, "Add 'pr_fmt()' format modifier to
> pr_xyz macros."), checkpatch spits out the following annoying error:
> 
> | ERROR: Macros with complex values should be enclosed in parenthesis
> | +#define pr_fmt(fmt)    "%s: " fmt, __func__
> 
> Unfortunately, adding parentheses is not a solution, as it creates illegal C
> code.

Yeah that one looks like something we should avoid.  Fixed in my next
update which can be tested here:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
