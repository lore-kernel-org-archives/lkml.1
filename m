Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbXFIQXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbXFIQXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 12:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbXFIQXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 12:23:09 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45020 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468AbXFIQXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 12:23:08 -0400
Date: Sat, 9 Jun 2007 18:24:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel/module.c warning re: non-GPL modules looks wrong
Message-ID: <20070609162409.GB31493@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0706090521250.28643@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706090521250.28643@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 05:25:08AM -0400, Robert P. J. Day wrote:
> 
>   from kernel/module.c:
> ...
>         ks = lookup_symbol(name, __start___ksymtab_gpl_future,
>                                  __stop___ksymtab_gpl_future);
>         if (ks) {
>                 if (!gplok) {
>                         printk(KERN_WARNING "Symbol %s is being used "
>                           "by a non-GPL module, which will not "
>                           "be allowed in the future\n", name);
>                         printk(KERN_WARNING "Please see the file "
>                           "Documentation/feature-removal-schedule.txt "
>                           "in the kernel source tree for more "
>                           "details.\n");
> ...
> 
>   but there's nothing in the feature removal file that expands on that
> issue.  (there *is* an entry regarding *unused* symbols, but that
> doesn't seem to address the above.)
EXPORT_GPL_FUTURE is used to mark _functionality_ as no longer available
after a grace period. So when one marks a set of symbols as GPL_FUTURE
that functionality ougt to be described in feature-removal.
Did you see any _functionaliy_ where GPL_FUTURE are used where it
is not warned in fetaure-removal that that _functionality_ are supposed
to be changed?

Or in other words - please be more specific.

	Sam
