Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbXFUFFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbXFUFFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 01:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXFUFFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 01:05:38 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:60811 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbXFUFFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 01:05:37 -0400
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: linux-kernel@vger.kernel.org
Subject: TUX2 filesystem
Date: Thu, 21 Jun 2007 07:05:34 +0200
User-Agent: KMail/1.9.7
Cc: phillips@istop.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706210705.34702.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel,
hello everbody else,


in Oct 2000 there's been some discussion "Tux2 - evil patents sighted" 
(http://www.ussg.iu.edu/hypermail/linux/kernel/0010.0/0343.html), and in Aug 
2002 (http://www.uwsg.iu.edu/hypermail/linux/kernel/0208.3/0332.html) Daniel 
wrote
> It's well down my list of priorities because of uncertainties due to
> the U.S. patent system. 
> Does anybody want to know if patent chill exists, and is it hurting
> open source? The answer is yes. 


With the recent Supreme Court decisions 
(http://www.groklaw.net/article.php?story=20070430121005424) and the fact 
that Daniel wrote that he did most of his work in *1989* (which is now 18 
years ago!) is there a chance for newer developments?


It seems to me that this kind of filesystem could solve a few problems that 
are currently attacked:
- Atomic snapshots. Make a new superblock, and mount this copy in another
  directory. As long as it's not overwritten, it stays consistent.
- Speed/Consistency for Flash media. There is a list of superblocks, and when
  the new block has been written the pointer from the old gets set - until the
  first block in the list gets re-written.

There may be some other nice things I didn't think about - but just having 
this filesystem for harddisks might be good, too.


Regards,

Phil
