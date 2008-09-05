Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYIEVHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYIEVHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 17:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYIEVHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 17:07:12 -0400
Received: from quechua.inka.de ([193.197.184.2]:39391 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbYIEVHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 17:07:11 -0400
X-Greylist: delayed 1847 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2008 17:07:11 EDT
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [NFS] blocks of zeros (NULLs) in NFS files in kernels >= 2.6.20
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <20080905200455.GH22796@merfinllc.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1Kbi2X-0000y3-00@calista.eckenfels.net>
Date: Fri, 05 Sep 2008 22:36:21 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20080905200455.GH22796@merfinllc.com> you wrote:
> OK.  Could you also try to reproduce on your side using those python
> programs?  I want to make sure it's not something specific with our
> mounts, etc.

sounds like the inode sync comes before the data sync. I suspect thats a
client side "problem". Maybe a fsync on the dir or something while the file
is open?

Bernd
