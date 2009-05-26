Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZEZVN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZEZVN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZEZVNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:13:47 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:48246 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZEZVNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:13:46 -0400
MIME-Version: 1.0
In-Reply-To: <1243372199.2815.77.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0905261508210.9278-100000@iolanthe.rowland.org> 
	<1243372199.2815.77.camel@localhost.localdomain>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 26 May 2009 23:13:26 +0200
Message-ID: <ac3eb2510905261413r54e5bb18n7faf888aa55d8830@mail.gmail.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs 
	directories.
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 23:09, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2009-05-26 at 15:29 -0400, Alan Stern wrote:

>> If you don't mind trashing some more ext3 root filesystems :-) you can
>> try this patch.  It's almost certainly not quite the right thing to do
>> and I have probably messed up the target's reference counting, but
>> maybe it's a step in the right direction.

> It's hard to follow the problem without full context, but if I
> understand correctly the problem is you want all the target directories
> removed before you call device_del() on the host and the thing that gets
> in the way is the necessary user context removal of the host.  So a
> simple solution, rather than mucking with the way it works, is to wait
> for the workqueues to complete.  Does this fix it?

Ok, I copied my newly installed system to another disks, to have a
root filesytem to trash again by this bug. :)

Which of your patches should I try?

Thanks,
Kay
