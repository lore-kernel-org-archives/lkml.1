Return-Path: <linux-kernel-owner+w=401wt.eu-S933373AbXGUTk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373AbXGUTk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765525AbXGUTkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:40:37 -0400
Received: from 1wt.eu ([62.212.114.60]:3858 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764995AbXGUTkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:40:35 -0400
Date: Sat, 21 Jul 2007 21:40:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFH] Partion table recovery
Message-ID: <20070721194027.GH943@1wt.eu>
References: <200707200813.03553.a1426z@gawab.com> <4FEA8E81-3BA7-4F8C-AFD2-6B93487A9AD5@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEA8E81-3BA7-4F8C-AFD2-6B93487A9AD5@cam.ac.uk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 08:35:45AM +0100, Anton Altaparmakov wrote:
> On 20 Jul 2007, at 06:13, Al Boldi wrote:
> >As always, a good friend of mine managed to scratch my partion  
> >table by
> >cat'ing /dev/full into /dev/sda.  I was able to push him out of the  
> >way, but
> >at least the first 100MB are gone.  I can probably live without the  
> >first
> >partion, but there are many partitions after that, which I hope should
> >easily be recoverable.
> >
> >I tried parted, but it's not working out for me.  Does anybody know  
> >of a
> >simple partition recovery tool, that would just scan the disk for lost
> >partions?
> 
> parted and its derivatives are pile of crap...  They cause corruption  
> to totally healthy systems at the best of times.  Don't go near them.
> 
> Use TestDisk (http://www.cgsecurity.org/wiki/TestDisk) and be happy.   
> (-:

Thanks for this link Anton, it looks awesome and I'll add it to my
collection :-)

I mostly use vche (virtual console hex editor) to look for strings, find
offsets and/or fix data by hand. This should make me save some time !

Regards,
Willy

