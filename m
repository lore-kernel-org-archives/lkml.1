Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbXITX3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbXITX3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 19:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXITX3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 19:29:06 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45412
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751960AbXITX3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 19:29:04 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Joe Perches <joe@perches.com>
Subject: Re: [Announce] Linux-tiny project revival
Date: Thu, 20 Sep 2007 19:28:49 -0500
User-Agent: KMail/1.9.6
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny@selenic.com,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
References: <46F1645D.9050406@am.sony.com> <46F2ED1E.3090407@am.sony.com> <1190326465.26101.171.camel@localhost>
In-Reply-To: <1190326465.26101.171.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201928.49440.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007 5:14:25 pm Joe Perches wrote:
> On Thu, 2007-09-20 at 14:58 -0700, Tim Bird wrote:
> > Given that there are about 60,000 printks in the kernel (and that's
> > not counting wrappers like dprintk() and other locally-defined
> > functions and macros) it would be a huge task to examine the code
> > and differentiate strings that really start a new log message
> > (and thus should have an attached log level) and strings
> > that don't.
>
> I've converted most all of that treewide.
>
> printk(KERN_<level> to pr_<level>(
>
> It's pretty automated.

Perl, being a write-only language, does not help my poor little brain 
understand what's going on.  You convert printk(KERN_INFO, blah) to 
pr_INFO(blah)?  I'm not finding pr_INFO with a grep on the files in 
2.6.23-rc7.  Is this something you added?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
