Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbZLUBor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbZLUBor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZLUBoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:44:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:38077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZLUBoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:44:46 -0500
Message-ID: <4B2ED29B.7060108@kernel.org>
Date: Sun, 20 Dec 2009 17:42:51 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 0/12] pci: update pci bridge resources
References: <4B2BEC0E.3050909@kernel.org> <1261352672.26429.41.camel@dc7800.home>
In-Reply-To: <1261352672.26429.41.camel@dc7800.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Fri, 2009-12-18 at 12:54 -0800, Yinghai Lu wrote:
>> this patche set is trying to update pci bridge BAR when that BAR is big enough.
>>
>> default it is disabled.
>>
>> could use pci=try=2 to enable it.
> 
> Thanks for posting this as a nice new series.  It was getting hard to
> figure out what went where.
> 
> I think you mean "when the BAR is *not* big enough."  And strictly
> speaking, I think you're concerned with the bridge *window*, which isn't
> actually a bridge BAR.

in PCI bridge to bridge spec 1.1, page 38, 3.2.5.1 still call them bridge "Base Address Registers"

so should be fine we call them Bridge BAR, 

and we still have device BAR...

> 
> I don't like the new "pci=try=2" parameter.  Linux should be smart
> enough to do the right thing without requiring the user to do something
> special.  Using a parameter to enable the new code makes it feel like
> "here's some new functionality, but I'm not sure it's safe enough for
> everybody to use, so try this parameter if you need it."

try to get the code merge at first. those code have been there for a while.
it should be good enable it by default

> 
> The result is that the new code will be rarely used and poorly tested,
> yet it remains a burden to all future PCI maintainers, who will have to
> understand it and try not to break it.
> 
> Can you please put the "-v2"-type comments about your development
> history in the [0/n] email?  They are useful while reviewing the
> different versions, but they don't need to be in the commit logs.

actually it should be -v14.

will put back the history later.

> 
> Also, some of the patches in this series have "-v2" in subject, others
> have "-v3", others have nothing.  It's easier to follow development of
> the series if the version applies to the series as a whole, not to
> individual patches.  The version doesn't need to be on the patch subject
> line, because that will go into the commit log, where it won't be
> relevant.  Tools like stgit put it where it will be automatically
> discarded, e.g., "[PATCH -v2 x/n]"

ok. will try that on next time.

YH

