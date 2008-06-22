Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbYFVErR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbYFVErR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 00:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbYFVErG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 00:47:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:50763 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYFVErE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 00:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Qp10sXbg7OSJ6eKJlro848CDSKcJr5jUgaRs+HW3CbY00qCNKaBxggPCW//qS/7b+v
         hwczMZ8gShuBhIPNKX+nKaes+L4tULfYk1mRRQb/7WU7I0HjHB4oy6XAQmccNgP7/h4B
         EQtTrR6jSlCYKOIcKkVYHZjy0WW8mz6Akd6BM=
Message-ID: <485DD93A.6020600@gmail.com>
Date: Sun, 22 Jun 2008 13:46:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Benjamin Thery <benjamin.thery@bull.net>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 05/11] sysfs: sysfs_chmod_file handle multiple superblocks
References: <20080618170729.808539948@theryb.frec.bull.fr> <20080618170730.853353875@theryb.frec.bull.fr>
In-Reply-To: <20080618170730.853353875@theryb.frec.bull.fr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.  Sorry about the long silence.  Recent releases of
popular distros overwhelmed me with ata bugs.  They now seem to be
under control (and hopefully stay that way for some time to come).

On the previous iteration, I was hoping I could sort out sysfs
interface problem before this patchset but given that this is a long
overdue feature, I think we should get this thing working first.

The first four patches looked good to me, so feel free to add
Acked-by: Tejun Heo <tj@kernel.org>

Benjamin Thery Wrote:
> sysfs: sysfs_chmod_file handle multiple superblocks
> 
> Teach sysfs_chmod_file how to handle multiple sysfs
> superblocks.

I think it would be great if sysfs_chmod_file can do all-or-nothing
instead of failing half way through but given the interface of
notify_change(), it could be difficult to implement.  Any ideas?

Thanks.

-- 
tejun
