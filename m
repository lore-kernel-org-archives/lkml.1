Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbYFWVnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbYFWVnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYFWVm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:42:59 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:48210 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbYFWVm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:42:59 -0400
Message-ID: <486018CB.80005@fr.ibm.com>
Date: Mon, 23 Jun 2008 23:42:35 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 05/11] sysfs: sysfs_chmod_file handle multiple superblocks
References: <20080618170729.808539948@theryb.frec.bull.fr> <20080618170730.853353875@theryb.frec.bull.fr> <485DD93A.6020600@gmail.com>
In-Reply-To: <485DD93A.6020600@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, guys.  Sorry about the long silence.  Recent releases of
> popular distros overwhelmed me with ata bugs.  They now seem to be
> under control (and hopefully stay that way for some time to come).
> 
> On the previous iteration, I was hoping I could sort out sysfs
> interface problem before this patchset but given that this is a long
> overdue feature, I think we should get this thing working first.
> 
> The first four patches looked good to me, so feel free to add
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Benjamin Thery Wrote:
>> sysfs: sysfs_chmod_file handle multiple superblocks
>>
>> Teach sysfs_chmod_file how to handle multiple sysfs
>> superblocks.
> 
> I think it would be great if sysfs_chmod_file can do all-or-nothing
> instead of failing half way through but given the interface of
> notify_change(), it could be difficult to implement.  Any ideas?

Is it acceptable to queue the notifications in a list until we are in 
the loop and loop again to notify when exiting the first loop without 
error ?
