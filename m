Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXD1Jg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXD1Jg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 05:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXD1Jg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 05:36:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2681 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753559AbXD1Jg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 05:36:28 -0400
Date: Sat, 28 Apr 2007 09:35:11 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Karuna sagar K <karunasagark@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Testing framework
Message-ID: <20070428093510.GA7479@ucw.cz>
References: <2e4afe1e0704221346u6d6baec1uab88dc273ff08de9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e4afe1e0704221346u6d6baec1uab88dc273ff08de9@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> For some time I had been working on this file system 
> test framework.
> Now I have a implementation for the same and below is 
> the explanation.
> Any comments are welcome.
> 
> Introduction:
> The testing tools and benchmarks available around do not 
> take into
> account the repair and recovery aspects of file systems. 
> The test
> framework described here focuses on repair and recovery 
> capabilities
> of file systems. Since most file systems use 'fsck' to 
> recover from
> file system inconsistencies, the test framework 
> characterizes file
> systems based on outcomes of running 'fsck'.

Thanks for your work.

> Putting it all together:
> The Corruption, Repair and Comparison phases could be 
> repeated a
> number of times (each repetition is called an iteration) 
> before the
> summary of that test run is prepared.
> 
> TODO:
> Account for files in the lost+found directory during the 
> comparison phase.
> Support for other file systems (only ext2 is supported 
> currently)

Yes, please. ext2 does really well in fsck area, unfortunately some
other filesystems (vfat, reiserfs) do not work that well.

						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
