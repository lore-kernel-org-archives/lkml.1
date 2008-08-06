Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYHFNop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYHFNop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYHFNog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:44:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:50311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYHFNof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:44:35 -0400
Date: Wed, 6 Aug 2008 06:44:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: "Rik van Riel" <riel@redhat.com>, "Greg KH" <greg@kroah.com>,
       "Eric Paris" <eparis@redhat.com>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
Message-ID: <20080806064418.6afa0672@infradead.org>
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
References: <20080805103840.1aaa64a5@infradead.org>
	<2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	<20080805181141.GA10700@kroah.com>
	<2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
	<20080805205129.37d873f0@bree.surriel.com>
	<2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 08:10:53 -0400
"Press, Jonathan" <Jonathan.Press@ca.com> wrote:

> However...  This question about arguing for a flawed security
> technique is a good one, and in a way it gets to the heart of the
> philosophy of security.  Scan-on-close is admittedly incomplete as an
> anti-virus tool. But I don't agree that that make it flawed.   It is
> part of a repertoire of techniques for preventing malware from
> residing on a machine.

this indeed gets to the heart of the problem.
several of us here are trying to argue that scan-on-close isn't very
good, BUT that if you do scan-on-change (say with inotify) you do reach
the same goal but with much better results.

notice the "but" in there. What I hope will happen is that one or more
people from the AV side (eg you and tvrtko) will actually read the "but"
part rather than just dismissing it outright because of not liking your
solution in the first part of it. Part of the answer could be "nice
however our goal is <THIS> so it won't work because of <THAT>".
At least as long as <THIS> isn't "scan on close" because that's not a
goal, that's a means.

this kind of thing seems to be indicative of the entire discussion.
For lkml proposals, both sides need to be willing to accept alternative
solutions for a problem (I know I am, just need to see why ;-).. and
explain the WHY and the goal if it's not clear.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
