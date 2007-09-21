Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbXIUVC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbXIUVC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764976AbXIUUxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:53:43 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58199
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764971AbXIUUxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:53:41 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: printk proposal - (was Linux-tiny project revival)
Date: Fri, 21 Sep 2007 15:53:35 -0500
User-Agent: KMail/1.9.6
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny@selenic.com,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
References: <46F1645D.9050406@am.sony.com> <46F2D695.5070500@am.sony.com> <20070921190738.GB1857@martell.zuzino.mipt.ru>
In-Reply-To: <20070921190738.GB1857@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211553.35857.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2007 2:07:38 pm Alexey Dobriyan wrote:
> On Thu, Sep 20, 2007 at 01:22:45PM -0700, Tim Bird wrote:
> > Alexey Dobriyan wrote:
> > > Given that
> > > a) there're plenty of printks without any KERN_* bloat,
> > > b) there're printks that SHOULD NOT have KERN_* bloat,
> >
> > Just to clarify, which bloat are you concerned about?
> > I presume source code bloat (but maybe you mean
> > message size bloat, or object code bloat)?
>
> Users of ignore_loglevel still has "<[0-7]>" prefixes in kernel image,
> yes. On source level, too -- as someone who never saw value in them,
> KERN_* are just needless characters, making code harder to read.

Yeah, I bumped into this when I implemented dmesg for busybox.  (Had to parse 
and filter it out.)  That said, userspace kind of expects it now...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
