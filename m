Return-Path: <linux-kernel-owner+w=401wt.eu-S1763093AbXFEHba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763093AbXFEHba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763667AbXFEHbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:31:19 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:15209 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763623AbXFEHbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:31:18 -0400
Message-ID: <4665113E.5070908@sw.ru>
Date: Tue, 05 Jun 2007 11:31:10 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Vasily Averin <vvs@sw.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, linux-ext4@vger.kernel.org,
       Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com
Subject: Re: [RFC PATCH ext3/ext4] orphan list corruption due bad inode
References: <4663A0CE.102@sw.ru> <20070604190340.dba85bb0.akpm@linux-foundation.org> <4664FE80.4080801@sw.ru> <20070605061315.GA25760@infradead.org>
In-Reply-To: <20070605061315.GA25760@infradead.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Jun 05, 2007 at 10:11:12AM +0400, Vasily Averin wrote:
>>>>  	return d_splice_alias(inode, dentry);
>>>>  }
>>> Seems reasonable.  So this prevents the bad inodes from getting onto the
>>> orphan list in the first place?
>> make_bad_inode() is called from ext3_read_inode() that is called from iget() only.
> 
> Which is artefact of using the read_inode interface.  Please switch from
> iget to iget_locked and you can handle this case without ever inserting the
> "bad" inode into the inode hash.

Sorry, I do not understand your proposal. Could you please explain your idea in
more details?

thank you,
	Vasily Averin
