Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYCBBAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYCBBAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 20:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYCBBAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 20:00:25 -0500
Received: from ns.theshore.net ([67.18.92.50]:46168 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYCBBAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 20:00:24 -0500
X-Greylist: delayed 1012 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Mar 2008 20:00:20 EST
Message-ID: <47C9F818.4020200@theshore.net>
Date: Sat, 01 Mar 2008 19:43:04 -0500
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: virtualization@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Xen paravirt frontend block hang
References: <4772AC8E.7010007@theshore.net> <47C712EF.1060703@goop.org>
In-Reply-To: <47C712EF.1060703@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> I've been running this all night without seeing any problem.  I'm using 
> current x86.git#testing with a few local patches, but nothing especially 
> relevent-looking.

Meh .. what backend are you using?  We're using LVM volumes exported 
directly into the domUs like so:

disk =[ 'phy:vg1/xencaker-56392,xvda,w', ... ]

> Could you try the attached patch to see if it makes any difference?

Unfortunately we're still in the same place... pv_ops kernels are still 
hanging after heavy disk IO:

works - 2.6.18.x (from xen-unstable)
hangs - 2.6.25-rc3-git3
hangs - 2.6.25-rc3-git3 + your patch

Any other suggestions or debugging I can provide that would be useful to 
squash this?

-Chris

