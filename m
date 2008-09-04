Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYIDCVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYIDCVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 22:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYIDCUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 22:20:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:50115 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYIDCUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 22:20:52 -0400
Date: Wed, 3 Sep 2008 19:20:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Grant Coady <grant_lkml@dodo.com.au>, lkml <linux-kernel@vger.kernel.org>,
       reiserfs-devel@vger.kernel.org
Subject: Re: reiserfs  BUG in 2.6.27-rc5
Message-Id: <20080903192037.e39fa931.randy.dunlap@oracle.com>
In-Reply-To: <hs9ub49fbs1uu11540i0nmdeh143sqgo7f@4ax.com>
References: <48BEBCCB.9000506@oracle.com>
	<hs9ub49fbs1uu11540i0nmdeh143sqgo7f@4ax.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008 10:12:38 +1000 Grant Coady wrote:

> On Wed, 03 Sep 2008 09:35:23 -0700, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> >Running fsx-linux on x86_64.
> 
> Cannot duplicate here, can you tell me which fsx-linux (url) and how 
> called?  I'm running slamd64-12.1 on reiserfs3 here.


fsx-linux from akpm's ext3-tools tarball which is here:
  http://www.zip.com.au/~akpm/linux/patches/stuff/ext3-tools.tar.gz


Run command is (roughly, it's a large script with lots of options):

fsx-linux -l 100M -N 10000 -S 0 /tester/fsxtestfile


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
