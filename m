Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbXFVVqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbXFVVqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbXFVVpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:45:53 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46705
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760227AbXFVVpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:45:52 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg KH <greg@kroah.com>
Subject: Re: Rules on how to use sysfs in userspace programs
Date: Fri, 22 Jun 2007 17:46:02 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
References: <20070608203637.GA9259@kroah.com>
In-Reply-To: <20070608203637.GA9259@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706221746.03298.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 June 2007 16:36:37 Greg KH wrote:
> Over time there have been a number of problems when sysfs has changed in
> "unexpected" ways.  Here's a document that Kay wrote a while ago that
> I'd like to add to the kernel Documentation directory to help userspace
> programmers out.
>
> Any comments or critique of this is greatly appreciated.

Still catching up from my laptop dying.

I find the explanation of /sys/subsystem almost unintelligible.  What will the 
new one actually look like?

If I want to find all block devices in the system, it looks like I should now 
look at /sys/subsystem/block.  (And "subsystem" is not a variable here but 
the actual directory name?  I presume it moved for Feng Shui reasons.)  

If I want to find char devices, where do I look?  /sys/subsystem...  char?  
class?  Is a char device now anything under /sys/subsystem that is _not_ 
in /sys/subsystem/block?  (Minus bus devices?)  Is there a specific directory 
for these?

This document is highly polluted with what NOT to do.  I'm looking for a 
clear "what SHOULD I do", and it takes some wading to find it.  (Historical 
cruft about what not to do is potentially a separate document, it's not 
useful for people learning this stuff now who weren't playing with the legacy 
mechanisms.)  The description of /sys/subsystem spends so much time talking 
about old legacy issues it never gives a clear description of the new way of 
doing things, which is theoretically what this document is about...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
