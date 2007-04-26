Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbXDZHyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbXDZHyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933368AbXDZHyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:54:25 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56052 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933379AbXDZHyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:54:20 -0400
Message-Id: <1177574060.24811.1186654285@webmail.messagingengine.com>
X-Sasl-Enc: qwe3G3uHoze8iMzn0boySNF5EbnafTHa6yMe7DGSgA5T 1177574060
From: lkml777@123mail.org
To: lkml777@123mail.org, "Edward Shishkin" <edward@namesys.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       "Andi Kleen" <andi@firstfloor.org>
Cc: "Alex Zarochentsev" <zam@namesys.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Eric Hopper" <hopper@omnifarious.org>, "Lex Lyamin" <flx@msu.ru>,
       "William Heimbigner" <icxcnika@mar.tar.cc>,
       "Rik van Riel" <riel@redhat.com>, "Xu CanHao" <xucanhao@gmail.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20070423111939.c876c9cc.akpm@linux-foundation.org>
   <462E17AF.7090604@namesys.com>
   <1177459922.31000.1186391425@webmail.messagingengine.com>
Subject: Re: Question about Reiser4
In-Reply-To: <1177459922.31000.1186391425@webmail.messagingengine.com>
Date: Thu, 26 Apr 2007 00:54:20 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 19:03:12 +0400, "Edward Shishkin"
<edward@namesys.com> said:
> lkml777@123mail.org wrote:
> 
> >
> >As I understand it, the default Reiser4 DOES NOT USE any compression at
> >all, not even tail compression,
> >
> 
> ^tail compression^tail conversion
> Reiser4 does use tail conversion by default.
> 
> > but saves space by eliminating block
> >alignment wastage (tail compression is an option).
> >
> >So lets LOSE the statistics that involve compression. The results now
> >look like this:
> >
> >.-------------------------.
> >| FILESYSTEM | TIME |DISK |
> >| TYPE       |(secs)|USAGE|
> >.-------------------------.
> >|REISER4     | 3462 | 692 |
> >|EXT2        | 4092 | 816 |
> >|JFS         | 4225 | 806 |
> >|EXT4        | 4408 | 816 |
> >|EXT3        | 4421 | 816 |
> >|XFS         | 4625 | 779 |
> >|REISER3     | 6178 | 793 |
> >|FAT32       |12342 | 988 |
> >|NTFS-3g     |10414 | 772 |
> >.-------------------------.
> >
> >These results are still EXTREMELY GOOD for REISER4.
> >  
> >
> 
> Everything is not so simple in the science of testing..
> Would you please change direction of your activity to stressing
> instead of benchmarking? Caught oopses would have great value..
> OK?
> 
> Regards,
> Edward.
> 

Tail conversion is NOT compression,....

So what exactly is your point?

By "tail compression" I mean plugin ctail40, but since I was never able
to get it to work, maybe its not tail compression at all.
-- 
  
  lkml777@123mail.org

-- 
http://www.fastmail.fm - A fast, anti-spam email service.

