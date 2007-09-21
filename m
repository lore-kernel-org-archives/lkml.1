Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbXIUXFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbXIUXFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763215AbXIUXF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:05:28 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50416
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762994AbXIUXF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:05:27 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Joe Perches <joe@perches.com>
Subject: Re: [Announce] Linux-tiny project revival
Date: Fri, 21 Sep 2007 18:05:22 -0500
User-Agent: KMail/1.9.6
Cc: Valdis.Kletnieks@vt.edu, Indan Zupancic <indan@nul.nu>,
       linux-tiny@selenic.com, Michael Opdenacker <michael@free-electrons.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <46F1645D.9050406@am.sony.com> <10228.1190394985@turing-police.cc.vt.edu> <1190396728.32660.42.camel@localhost>
In-Reply-To: <1190396728.32660.42.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211805.22458.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2007 12:45:27 pm Joe Perches wrote:
> On Fri, 2007-09-21 at 13:16 -0400, Valdis.Kletnieks@vt.edu wrote:
> > What about something *really* hardcore ugly like:
> > #ifdef __FILE__
> > #undef __FILE__
> > #define __FILE__ ""
> > #endif
> > (or similar preprocessor blecherousness) if you want to *really* shrink
> > that binary down?
>
> I prefer removing all __FILE__, __FUNCTION__, __LINE__ uses
> from printks and defining something that modifies pr_<level>.

pr_level doesn't exist in mainline.

> #define pr_info(fmt, arg) printk(KERN_INFO PR_FMT fmt PR_ARG, ##arg)

Do we really need another layer of indirection?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
