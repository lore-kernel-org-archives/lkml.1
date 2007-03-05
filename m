Return-Path: <linux-kernel-owner+w=401wt.eu-S1751345AbXCEWHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbXCEWHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbXCEWHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:07:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbXCEWHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:07:14 -0500
Message-ID: <45EC92E6.3030503@redhat.com>
Date: Mon, 05 Mar 2007 16:00:06 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@lazybastard.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ulrich Drepper <drepper@redhat.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
References: <20070117094658.GA17390@amitarora.in.ibm.com> <45EB4A55.3060908@redhat.com> <20070305001621.GB18691@lazybastard.org> <200703050136.37181.arnd@arndb.de> <20070305114109.GA454@lazybastard.org>
In-Reply-To: <20070305114109.GA454@lazybastard.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> Does the allocation have to be persistent beyond lifetime of the file
> descriptor?  It would be fairly simple to support the write guarantee
> while the file is open (or rather the inode remains cached) and drop it
> afterwards.

"The posix_fallocate() function shall ensure that any required storage
for regular file data starting at offset and continuing for len bytes is
allocated on the file system storage media."

I interpret "on the storage media" to mean that it is persistent.

-Eric
