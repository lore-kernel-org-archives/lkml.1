Return-Path: <linux-kernel-owner+w=401wt.eu-S1946380AbXD3Qsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946380AbXD3Qsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946381AbXD3Qsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:48:54 -0400
Received: from mail.chehov.net ([80.71.245.247]:51419 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946380AbXD3Qsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:48:53 -0400
X-Greylist: delayed 1427 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Apr 2007 12:48:52 EDT
X-Spam-Flag: SKIP
X-Spam-Yversion: Spamooborona 1.6.1
Message-ID: <4636184F.3030206@clusterfs.com>
Date: Mon, 30 Apr 2007 20:24:47 +0400
From: Alex Tomas <alex@clusterfs.com>
Organization: Cluster Filesystems, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070302 Fedora/1.5.0.10-1.fc6 pango-text Thunderbird/1.5.0.10 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-ext4@vger.kernel.org, Johann Lombardi <johann.lombardi@bull.net>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>, Dave Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-ext4-1
References: <E1HiXab-0001QX-Sk@candygram.thunk.org>
In-Reply-To: <E1HiXab-0001QX-Sk@candygram.thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o wrote:
> P.S.  One bug which I've noted --- if there is a failure due to disk
> filling up, running e2fsck on the filesystem will show that the i_blocks
> fields on the inodes where there was a failure to allocate disk blocks
> are left incorrect.  I'm guessing this is a bug in the delayed
> allocation patches.  Alex, when you have a moment, could you take a
> look?  Thanks!!

definitely. thanks for the report.

thanks, Alex


