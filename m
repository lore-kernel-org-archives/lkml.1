Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYLZS1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYLZS1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 13:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYLZS1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 13:27:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37633 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYLZS1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 13:27:12 -0500
Date: Fri, 26 Dec 2008 19:27:02 +0100
From: Pavel Machek <pavel@suse.cz>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, shaohua.li@intel.com
Subject: Re: [PATCH] ASPM: Use msleep instead of cpu_relax during link
	retraining
Message-ID: <20081226182702.GA1528@ucw.cz>
References: <20081222221156.29645.95982.stgit@bluto> <20081225190129.GA1615@ucw.cz> <20081225232427.GJ19967@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225232427.GJ19967@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-12-25 16:24:27, Matthew Wilcox wrote:
> On Thu, Dec 25, 2008 at 08:01:29PM +0100, Pavel Machek wrote:
> > On Mon 2008-12-22 15:11:57, Andrew Patterson wrote:
> > > ASPM: Use msleep instead of cpu_relax during link retraining
> > > 
> > > The cpu_relax() function can be a noop on certain architectures
> > > like IA-64 when CPU threads are disabled, so use msleep instead
> > > during link retraining busy/wait loop.
> > 
> > Author clearly wanted to do a busy loop... why do you think 10msec
> > delay here is acceptable?
> 
> 10ms?  I see a 1ms sleep.

Yes... IIRC msleep will sleep for up-to 1/HZ on non-highres systems.

> Yes, the subsequent test should be of reg16 instead of jiffies.

Thanks.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
