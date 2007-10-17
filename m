Return-Path: <linux-kernel-owner+w=401wt.eu-S1760792AbXJQX0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792AbXJQX0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 19:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbXJQX0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 19:26:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49458 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755833AbXJQX0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 19:26:11 -0400
Date: Wed, 17 Oct 2007 16:25:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
Cc: kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net, tytso@mit.edu
Subject: Re: [PATCH 0/4] Fix PCIe hotplug for non-ACPI ExpressCard slots
 (version 2)
Message-Id: <20071017162553.986a0f70.akpm@linux-foundation.org>
In-Reply-To: <471693DF.4020608@rtr.ca>
References: <4714C0A6.1030204@rtr.ca>
	<4714D700.7060008@rtr.ca>
	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>
	<47150565.5090102@rtr.ca>
	<20071016114328.a96e8bcb.kristen.c.accardi@intel.com>
	<47150982.6050102@rtr.ca>
	<471509FE.7080505@rtr.ca>
	<47151191.40406@rtr.ca>
	<20071016130757.ed2f2ce4.kristen.c.accardi@intel.com>
	<4715217D.2000803@rtr.ca>
	<20071016214143.GC21815@kroah.com>
	<471533AF.60100@rtr.ca>
	<47156B14.2080608@rtr.ca>
	<20071017150243.1c21fea4.akpm@linux-foundation.org>
	<471693DF.4020608@rtr.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 18:59:43 -0400
Mark Lord <lkml@rtr.ca> wrote:

> Andrew Morton wrote:
> > On Tue, 16 Oct 2007 21:53:24 -0400
> > Mark Lord <lkml@rtr.ca> wrote:
> > 
> >> Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
> >> in conjunction with the modparam of pciehp_force=1.
> >>
> >> The PCIe Hotplug driver has two shortcomings when used on Dell notebooks
> >> which lack ACPI BIOS support for PCIe hotplug:
> > 
> > You just sent four patches all of which are identified as "Fix PCIe hotplug
> > for non-ACPI ExpressCard slots (version 2)".  Please do not do this.
> 
> Eh?  They were labelled as 1/4, 2/4, 3/4, and 4/4.

Please, review http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt -
a lot of experiecne has gone into that...

When preparing patches, always think "how will this appear to someone who
is reading it in the git tree a year from now".

Obviously stuff like "[patch 2/4]" won't be there, because it is
meaningless once the patch hits the git tree.  Also text such as "the previous
patch" and "my patch from yesterday" and "John Doe's comments" and lots of
other stuff which is appropriate to an email conversation is _not_
appropriate to a permanent git commit.

> But I'll make the rest of the subject line unique as well on resubmit, then.
> 

Thanks.  That's much better than having me invent the subject, because when
you choose the title, everyone agrees on what the patch is _called_ (as
long as the title isn't so poorly chosen that I have to fix it).

If the patch title is well-chosen then it becomes a nice google search key,
so if someone wants to find out what we were thinking when we did a
particular patch two years ago, they can just google for the title and go
and read all the email discussion.

> 
> So far, two postings, and zero comments from anyone on the actual code.

Actual code?  That sounds hard ;)
