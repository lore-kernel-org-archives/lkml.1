Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbXIAQuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbXIAQuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 12:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbXIAQtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 12:49:55 -0400
Received: from kallisti.us ([67.59.168.233]:42412 "EHLO kallisti.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbXIAQtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 12:49:55 -0400
X-Greylist: delayed 977 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Sep 2007 12:49:55 EDT
From: Ross Vandegrift <ross@kallisti.us>
Date: Sat, 1 Sep 2007 12:33:35 -0400
To: Dan Stromberg <dstromberglists@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ifconfig changing a routing table?
Message-ID: <20070901163335.GB13190@kallisti.us>
References: <fb83g8$nac$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb83g8$nac$1@sea.gmane.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 03:55:53AM +0000, Dan Stromberg wrote:
> Is anyone on the list familiar with ifconfig up and/or ip link up 
> changing a routing table?  How does the kernel decide what route to add 
> in such a circumstance?

By the parameteres you supplied for the interface configuration.

So, if you're getting a connected route for 10.3.0.0/16 out of dev
eth0, it's because you assigned some IP in that subnet to that device,
with a netmask of 255.255.0.0

Check that your netmask is correct.


-- 
Ross Vandegrift
ross@kallisti.us

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
