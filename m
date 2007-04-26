Return-Path: <linux-kernel-owner+w=401wt.eu-S1423468AbXDZAoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423468AbXDZAoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423473AbXDZAoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:44:25 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59771 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423468AbXDZAoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:44:24 -0400
Message-Id: <1177548263.28057.1186607807@webmail.messagingengine.com>
X-Sasl-Enc: wjteSi6sFDRj99GlvG/canBo2FjJnDa5ZYiHIREgNekW 1177548263
From: lkml777@123mail.org
To: "Edward Shishkin" <edward@namesys.com>
Cc: linux-kernel@vger.kernel.org, "Eric Hopper" <hopper@omnifarious.org>,
       "William Heimbigner" <icxcnika@mar.tar.cc>,
       "Alex Zarochentsev" <zam@namesys.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Rik van Riel" <riel@redhat.com>,
       "Xu CanHao" <xucanhao@gmail.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20070423111939.c876c9cc.akpm@linux-foundation.org>
   <462E17AF.7090604@namesys.com>
   <20070424193921.GA17129@one.firstfloor.org>
   <462F6717.70508@namesys.com>
Subject: Re: Question about Reiser4
In-Reply-To: <462F6717.70508@namesys.com>
Date: Wed, 25 Apr 2007 17:44:23 -0700
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
http://www.fastmail.fm - Or how I learned to stop worrying and
                          love email again

