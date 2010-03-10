Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0CJBWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 20:22:31 -0500
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:50737 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304Ab0CJBW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 20:22:29 -0500
From: Frans Pop <elendil@planet.nl>
To: Joe Perches <joe@perches.com>
Subject: Re: Tuxradar patching article and [PATCH] scripts/cvt_kernel_style.pl
Date: Wed, 10 Mar 2010 02:22:25 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, devel@driverdev.osuosl.org,
       apw@shadowen.org
References: <1268177526.1545.62.camel@Joe-Laptop.home>
In-reply-To: <1268177526.1545.62.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003100222.27201.elendil@planet.nl>
X-OriginalArrivalTime: 10 Mar 2010 01:22:28.0045 (UTC) FILETIME=[25C8BFD0:01CABFF0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> The article recommends running checkpatch and fixing the various
> non-conforming style elements the output produces.

Hmm. I thought that "style cleanup only" patches were generally frowned 
upon? For one because it requires some familiarity with the kernel coding 
style to make sane choices in situations that are debatable and blindly 
following checkpatch is seldom good. And also to avoid needless merge 
issues.
I've seen several patches drift by the last few days where I thought some 
of the changes were definitely not improvements.

> Convert printk(KERN_<level> to pr_<level>(
> Removes unnecessary parenthesis from return
> Add space after if, for and while
> Convert "for (foo;bar;baz)" to "for (foo; bar; baz)"
> Removes multiple semicolons
> Convert leading spaces to tabs

Maybe I missed it, but you should certainly add removal of trailing space.
And possibly remove spaces before the closing ";" after statements.

Maybe the script should print a large warning (unless -q is used?) that all 
changes should be carefully reviewed manually and not combined with 
functional changes, and have a pointer to Documentation/SubmittingPatches?

Cheers,
FJP

P.S.
I wonder what traffic the advice to mail lkml when "I have a line of code 
that's over 80 chars" is going to generate...
