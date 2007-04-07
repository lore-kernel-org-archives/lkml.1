Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbXDGTRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbXDGTRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 15:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965706AbXDGTRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 15:17:18 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:51465 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbXDGTRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 15:17:16 -0400
Date: Sat, 7 Apr 2007 15:17:15 -0400
To: johnrobertbanks@fastmail.fm
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ignatich <ignatich@gmail.com>,
       reiserfs-list@namesys.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
Message-ID: <20070407191715.GG3510@csclub.uwaterloo.ca>
References: <46157B5B.5000602@gmail.com> <1175817921.18400.1183285196@webmail.messagingengine.com> <461592FB.5060507@zytor.com> <1175819681.20754.1183287946@webmail.messagingengine.com> <461596DE.2020802@zytor.com> <1175823288.25662.1183293506@webmail.messagingengine.com> <4615C780.5040407@zytor.com> <1175833931.8916.1183307802@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175833931.8916.1183307802@webmail.messagingengine.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 09:32:11PM -0700, johnrobertbanks@fastmail.fm wrote:
> Don't you agree, that "If they are accurate,.... THEN they are obviously
> very relevant."

Nope, if they are accurate and they have something to do with your
particular usage and applications, then they are relevant.  But it
requires both to make them relevant.  Although it may be possible for a
benchmark to be relevant even if not particularly accurate.

> I have set up a Reiser4 partition with gzip compression, here is the
> difference in disk usage of a typical Debian installation on two 10GB
> partitions, one with Reiser3 and the other with Reiser4.
> 
> debian:/# df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sda3             10490104   6379164   4110940  61% /3
> /dev/sda7              9967960   2632488   7335472  27% /7
> 
> Partitions 3 and 7 have exactly the same data on them (the typical
> Debian install).
> 
> The partitions are exactly the same size (although df records different
> sizes).
> 
> Partition 3 is Reiser3 -- uses 6.4 GB.
> Partition 7 is Reiser4 -- uses 2.6 GB.
> 
> So Reiser4 uses 2.6 GB to store the (typical) data that it takes Reiser3
> 6.4 GB to store (note it would take ext2/3/4 some 7 GB to store the same
> info).
> 
> Don't you think this result is significant in itself?

Only if you think disk space is so valuable that trading cpu time to
compress and decompress the data is a good trade off.  It is not one I
would want to make.  So you saved 3GB, what is that?  About $1 worth?
maybe $2 if you have raid.  How much extra time and cpu will it take to
access the data that way?  How much extra electricity will the cpu use?
What is your time worth?  There are so many variables.  Do you _trust_
reiserfs4 to not loose your data any more or less than some other
filesystem?

--
Len Sorensen
