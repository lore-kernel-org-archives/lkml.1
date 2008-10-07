Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbYJGWgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbYJGWgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbYJGWgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:36:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37388 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbYJGWgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:36:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Mark Ryden <markryde@gmail.com>, Benjamin Thery <benjamin.thery@bull.net>,
       David Shwatrz <dshwatrz@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org
References: <m1hc9e27ya.fsf_-_@frodo.ebiederm.org> <48B57058.9000101@bull.net>
	<dac45060809020654g62afb3c9yd104682b93b43bee@mail.gmail.com>
	<48BD47A8.1080909@bull.net> <20080902170148.GA9305@suse.de>
	<31436f4a0809032233r2c46de8od8a94460ce3b5ed2@mail.gmail.com>
	<48BF83E1.5040000@bull.net>
	<dac45060810070939v80918a0m3963d7fc6fcbb975@mail.gmail.com>
	<20081007164833.GA16056@suse.de> <m1abdgywnb.fsf@frodo.ebiederm.org>
	<20081007210902.GB7996@suse.de>
Date: Tue, 07 Oct 2008 15:27:12 -0700
In-Reply-To: <20081007210902.GB7996@suse.de> (Greg KH's message of "Tue, 7 Oct
	2008 14:09:02 -0700")
Message-ID: <m18wt0qbwf.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4852]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/8] sysfs: Implement sysfs tagged directory support.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Tue, Oct 07, 2008 at 01:31:52PM -0700, Eric W. Biederman wrote:
>> Greg KH <gregkh@suse.de> writes:
>> 
>> > On Tue, Oct 07, 2008 at 06:39:04PM +0200, Mark Ryden wrote:
>> >> Hello,
>> >>   So I wonder: the sysfs tagged directory support patch is in GerKH
>> >> tree for more than a month.
>> >
>> > I dropped it from my tree 2 days ago, see the thread on lkml for why.
>> 
>> Greg why did you drop it? 
>
> Because Al said it was full of problems and for us not to accept it.

Yes. Al found problems.

Al reviewed sysfs with my patchset on top of it.

Al's review found problems in  sysfs with my patchset on top of it.

If you look at what Al found the majority of those problems exist in sysfs
without my patches.

Does the following sound like a workable path going forward?

- Not merge for 2.6.28 (we are to close to the merge window for everyone's comfort).

- Fix the small issues specific to tagged directory support that showed
  up in Al's review (patches sent).

- Keep the patches the entire time in a public tree that merges into
  linux-next so that people treat this code base seriously.

- Resolve the sysfs/vfs lock ordering problem mess that makes
  locking in sysfs excruciatingly difficult.

- Merge other patches to fix Als other issues with sysfs.

- Merge to 2.6.29 or wherever we are.


Eric

