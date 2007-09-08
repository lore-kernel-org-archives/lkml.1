Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbXIHDue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbXIHDue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 23:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXIHDu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 23:50:27 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57224 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbXIHDu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 23:50:26 -0400
X-Sasl-enc: iwfsf+f7gxn3XmfOsQGb1vasRsOEmye0fq50uTam6Rce 1189223425
Date: Sat, 8 Sep 2007 00:50:22 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org, gregkh@suse.de,
       dmitry.torokhov@gmail.com
Subject: Re: Platform device id
Message-ID: <20070908035022.GF4357@khazad-dum.debian.net>
References: <20070907153559.17faf9d1@hyperion.delvare> <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com> <20070907164129.65816B9389@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20070907210029.GB4357@khazad-dum.debian.net> <20070907214116.5051B237214@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20070907220407.GE4357@khazad-dum.debian.net> <20070908001835.C7F721B729B@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070908001835.C7F721B729B@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Sep 2007, David Brownell wrote:
> > The platform for a ThinkPad is either i386 or amd64.
> 
> Both i386 and x86_64 are clearly an "arch".  They even live in
> an "arch" directory:  linux/arch/{i386,x86_64}.

Well, I stand corrected on the "platform" term, then.

> When folk talk about a "PC Platform", they're talking about a
> thing that doesn't quite exist in today's Linux tree.  If we
> ever get to an arch/x86, that could have a plat-pc (or mach-pc)
> subdirectory.  ThinkPads should then be a variant of that.

You'd have so many, it wouldn't be funny.  It would also cause some
headaches for distros, unless one can have an "all platform" kernel or
somesuch.

> > I don't feel like drivers like hdaps, thinkpad-acpi, dock, bay,
> > and many others really belong in the platform bus.  But that's
> > what happens right now.
> 
> As a rule, there needs to be a Good Reason to create a new bus
> type.  A "feel" is a pretty weak reason...

The "feel" is there because:

1. Comments about how what we do is wrong for the platform bus (i.e.  adding
   the devices and the driver in the same module). Even the documentation
   for platform devices make it quite clear we are abusing it.  There was
   one of those comments in this very thread.

2. The fact that a module that has a number of different devices has to
   register itself a number of times as a driver, if it wants to name the
   devices something different...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
