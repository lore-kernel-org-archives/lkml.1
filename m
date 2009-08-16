Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZHPCTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZHPCTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 22:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZHPCTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 22:19:18 -0400
Received: from rtr.ca ([76.10.145.34]:49706 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbZHPCTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 22:19:17 -0400
Message-ID: <4A876CA9.20906@rtr.ca>
Date: Sat, 15 Aug 2009 22:19:21 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH, RFC] xfs: batched discard support
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca>
In-Reply-To: <4A876255.10606@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Christoph Hellwig wrote:
..
>> Mark, any chance to try it?  Just create an XFS filesystem, age it a
>> bit and then call the attached little trim.c program on the mountmoint
>> (or any file inside the filesystem for that matter)
> ..
> 
> Looking at it now.  Thanks, Christoph!
..

Fails to work on 64-bit kernel w/ 32-bit userspace (no compat ioctl).
Rebuilding with 32-bit kernel now..


