Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZHHWqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZHHWqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 18:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZHHWqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 18:46:53 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:34600 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZHHWqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 18:46:52 -0400
X-Greylist: delayed 1243 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Aug 2009 18:46:52 EDT
Date: Sun, 9 Aug 2009 00:25:53 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Greg K-H <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Martyn Welch <martyn.welch@gefanuc.com>,
       Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 0/5] [ANNOUNCE] VME Bus drivers and framework for Linux
Message-ID: <20090808222552.GA27151@braap.org>
References: <20090803210054.GA28430@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803210054.GA28430@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg K-H wrote:
> Hi all,
> 
> Here's 5 patches from Martyn Welch that adds VME Bus support to the
> kernel.
> 
> Martyn took the time and merged the three different existing
> implementations for Linux together into something that works, and got
> the proper legal agreements from all of the affected parties to release
> the code properly.
> 
> I'd like to thank him for taking the time to do this work, it is much
> appreciated.
> 
> These patches all add the code under the drivers/staging/ directory, as
> there is still a number of things that needs to be done to clean up the
> code to get it into "proper" mergable state, but it's a great first cut.
> 
> Thanks again Martyn!
> 
> greg k-h

whoops just spotted this.. I had allocated next month for working
on this, i.e. getting VME support into the kernel.

I work at CERN where we have hundreds of VME crates; we're
currently moving from LynxOS to real-time linux. The VME chipset
we're using is the tsi148, for which Sebastien Dugue wrote a
driver at the beginning of the year.

I'll reply to each of the relevant patches to comment on them.
Regards,
E.
