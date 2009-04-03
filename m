Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbZDCEHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbZDCEHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 00:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZDCEGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 00:06:52 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60276 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbZDCEGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 00:06:51 -0400
Date: Fri, 3 Apr 2009 00:06:49 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       tytso@mit.edu, drees76@gmail.com, jesper@krogh.cc,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
Message-ID: <20090403040649.GF3795@csclub.uwaterloo.ca>
References: <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402010044.GA16092@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 03:00:44AM +0200, Ingo Molnar wrote:
> I'll test this (and the other suggestions) once i'm out of the merge 
> window.
> 
> I probably wont test that though ;-)
> 
> Going back to v2.6.14 to do pre-mutex-merge performance tests was 
> already quite a challenge on modern hardware.

Well after a day of running my mythtv box with anticipatiry rather than
the default cfq scheduler, it certainly looks a lot better.  I haven't
seen any slowdowns, the disk activity light isn't on solidly (it just
flashes every couple of seconds instead), and it doesn't even mind
me lanuching bittornado on multiple torrents at the same time as two
recordings are taking place and some commercial flagging is taking place.
With cfq this would usually make the system unusable (and a Q6600 with
6GB ram should never be unresponsive in my opinion).

So so far I would rank anticipatory at about 1000x better than cfq for
my work load.  It sure acts a lot more like it used to back in 2.6.18
times.

-- 
Len Sorensen
