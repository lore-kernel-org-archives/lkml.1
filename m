Return-Path: <linux-kernel-owner+w=401wt.eu-S1764991AbXIUXJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764991AbXIUXJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762292AbXIUXJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:09:25 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4064 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762069AbXIUXJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:09:24 -0400
Subject: Re: [Announce] Linux-tiny project revival
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Valdis.Kletnieks@vt.edu, Indan Zupancic <indan@nul.nu>,
       linux-tiny@selenic.com, Michael Opdenacker <michael@free-electrons.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200709211805.22458.rob@landley.net>
References: <46F1645D.9050406@am.sony.com>
	 <10228.1190394985@turing-police.cc.vt.edu>
	 <1190396728.32660.42.camel@localhost>  <200709211805.22458.rob@landley.net>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 16:08:50 -0700
Message-Id: <1190416130.32660.73.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 18:05 -0500, Rob Landley wrote:
> > from printks and defining something that modifies pr_<level>.
> pr_level doesn't exist in mainline.

pr_info and pr_debug do.

pr_alert, pr_emerg, pr_crit, pr_err, and pr_warn could be added.

> > #define pr_info(fmt, arg) printk(KERN_INFO PR_FMT fmt PR_ARG, ##arg)
> Do we really need another layer of indirection?

It'd make file/function/line cost free for embedded use.

