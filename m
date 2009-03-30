Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbZC3DWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbZC3DWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 23:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZC3DWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 23:22:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43420 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZC3DWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 23:22:20 -0400
Message-ID: <49D03AE1.8070009@redhat.com>
Date: Sun, 29 Mar 2009 22:22:09 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
References: <200903291928.14451.bzolnier@gmail.com> <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu>
In-Reply-To: <20090330022521.GB13356@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Sun, Mar 29, 2009 at 12:43:22PM -0500, Eric Sandeen wrote:
>> As long as we keep the call there this is probably good, but after
>> talking w/ Chris Mason, I think the call is extraneous anyway and should
>> probably just be removed...
>>
> 
> Yes, I agree, but it takes a lot of digging to be completely sure of
> that it's safe to remove it.  Interestingly, it was you who added the
> patch which added the call to blkdev_issue_flush():

> commit d755fb384250d6bd7fd18a0930e71965acc8e72e
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Fri Jul 11 19:27:31 2008 -0400


Yes, it was.  Although I got the idea when hch pointed out that SuSE did
this... thanks to Chris.  It's come full circle.  :)

-Eric
