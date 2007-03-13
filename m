Return-Path: <linux-kernel-owner+w=401wt.eu-S1030524AbXCMOy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbXCMOy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 10:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030555AbXCMOy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 10:54:28 -0400
Received: from waste.org ([66.93.16.53]:60351 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030524AbXCMOy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 10:54:27 -0400
Date: Tue, 13 Mar 2007 09:41:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21rc suspend to ram regression on Lenovo X60
Message-ID: <20070313144136.GF10459@waste.org>
References: <20070313040828.GA17893@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313040828.GA17893@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 12:08:28AM -0400, Dave Jones wrote:
> I spent considerable time over the last day or so bisecting to
> find out why an X60 stopped resuming somewhen between 2.6.20 and current -git.
> (Total lockup, black screen of death).
> 
> The bisect log looked like this.
> 
...
> Any ideas how to further debug this?
> I'll try backing out individual changes from that merge tomorrow.

If you've got a tree that looks like:

 --a-b-c-d-e-f-g-h->
    \           /
     i-j-k-l-m-n

where h is bad but both g and n are good, you can try testing the
merge of g+k, etc. Which will find half the problem. Then you can do
the same on the other side. Tedious.

The best way to debug resume issues directly seems to be to do a fake
suspend, possibly with filtering out particular devices:

http://lwn.net/Articles/219033/
http://www.uwsg.iu.edu/hypermail/linux/kernel/0701.3/0397.html

-- 
Mathematics is the supreme nostalgia of our time.
