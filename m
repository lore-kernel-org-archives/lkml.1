Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbYJNDa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbYJNDa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 23:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYJNDaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 23:30:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49188 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYJNDaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 23:30:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg KH <gregkh@suse.de>, Mark Ryden <markryde@gmail.com>,
       Benjamin Thery <benjamin.thery@bull.net>,
       David Shwatrz <dshwatrz@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org
References: <dac45060809020654g62afb3c9yd104682b93b43bee@mail.gmail.com>
	<48BD47A8.1080909@bull.net> <20080902170148.GA9305@suse.de>
	<31436f4a0809032233r2c46de8od8a94460ce3b5ed2@mail.gmail.com>
	<48BF83E1.5040000@bull.net>
	<dac45060810070939v80918a0m3963d7fc6fcbb975@mail.gmail.com>
	<20081007164833.GA16056@suse.de> <m1abdgywnb.fsf@frodo.ebiederm.org>
	<20081007210902.GB7996@suse.de> <m18wt0qbwf.fsf@frodo.ebiederm.org>
	<20081008130006.GB31684@infradead.org>
Date: Mon, 13 Oct 2008 20:20:05 -0700
In-Reply-To: <20081008130006.GB31684@infradead.org> (Christoph Hellwig's
	message of "Wed, 8 Oct 2008 09:00:06 -0400")
Message-ID: <m11vyjrhga.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Christoph Hellwig <hch@infradead.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0904]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/8] sysfs: Implement sysfs tagged directory support.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, Oct 07, 2008 at 03:27:12PM -0700, Eric W. Biederman wrote:
>> Al reviewed sysfs with my patchset on top of it.
>> 
>> Al's review found problems in  sysfs with my patchset on top of it.
>> 
>> If you look at what Al found the majority of those problems exist in sysfs
>> without my patches.
>
> And when something is crap your fix it firdt before piling up more shit
> on top of it.  And sysfs is a really severe case of that, and you're
> piling a _lot_ of shit ontop.

Chistoph, your comments and Al's would have been much more productive
if you have had said:

"I didn't like sysfs because it doesn't do things the way other filesystems
  with similar problems do things.  Can you please use common idioms?
  Making the code easier to read and making the code easier to maintain.
  Some of those constructs look awfully complex can you recheck you code
  and see if there is a simpler way to implement them."

That would have been honest and productive.  As it sits.  I have partially
inaccurate feedback from Al, useless feedback from you, and only my own
tough skin and determination to keep me going..

The fact that you and Al look at the code and can't easily make sense of
is a good sign that the code as written will be hard to maintain.  Al's
recent breakage of sysctl is a good example of that.

Eric
