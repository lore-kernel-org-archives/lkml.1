Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXEBCjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXEBCjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 22:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964974AbXEBCjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 22:39:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44645 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932114AbXEBCja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 22:39:30 -0400
Message-Id: <1178073570.23207.1187618757@webmail.messagingengine.com>
X-Sasl-Enc: mEjunje9sbyERMYj251RWGTCRLNkRM9WckbsY34FuqKl 1178073570
From: lkml777@123mail.org
To: "Edward Shishkin" <edward@namesys.com>,
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
Subject: Re: Question about Reiser4
In-Reply-To: <462E17AF.7090604@namesys.com>
Date: Tue, 01 May 2007 19:39:30 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


OOn Wed, 25 Apr 2007 19:03:12 +0400, "Edward Shishkin"
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
http://www.fastmail.fm - mmm... Fastmail...

