Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0BMDU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 22:20:58 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48444 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0BMDU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 22:20:56 -0500
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 0/6] General sysfs enhancements
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
	<20100115213732.GA17838@kroah.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 12 Feb 2010 19:20:41 -0800
In-Reply-To: <20100115213732.GA17838@kroah.com> (Greg KH's message of "Fri\, 15 Jan 2010 13\:37\:32 -0800")
Message-ID: <m1mxzdstx2.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Mon, Jan 11, 2010 at 12:16:09PM -0800, Eric W. Biederman wrote:
>> 
>> This patchset is built on top of 2.6.33-rc3 +
>>   "sysfs: Cache the last sysfs_dirent to improve readdir scalability v2"
>> 
>> Greg I assume you have that patch somewhere in queue.
>
> It is now applied.
>
>> This patchset contains little cleanups all around sysfs.
>> - Some basic cleanups.
>> - Some sysfs scaling work 
>> - Implementation of sysfs_rename
>
> Care to resend these, as it seems that some needed to be redone.

Here goes. I am finally recovered enough from my cold to find the
time and energy to do this properly.

For now I am dropping the controversial and buggy nlink changing patch
from my patchset, I can come back to that another time.

Eric


