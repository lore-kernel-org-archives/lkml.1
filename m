Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbZKGCex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbZKGCex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 21:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbZKGCew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 21:34:52 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38614 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZKGCev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 21:34:51 -0500
To: Tejun Heo <tj@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 12/13] sysfs: Propagate renames to the vfs on demand
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<1257249429-12384-12-git-send-email-ebiederm@xmission.com>
	<20091104214938.GA21033@us.ibm.com> <m13a4ux86v.fsf@fess.ebiederm.org>
	<4AF4D76C.6090008@kernel.org> <m1y6mjw03m.fsf@fess.ebiederm.org>
	<4AF4D968.3040608@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
In-Reply-To: <4AF4D968.3040608@kernel.org> (Tejun Heo's message of "Sat\, 07 Nov 2009 11\:20\:24 +0900")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Date: Fri, 06 Nov 2009 18:34:35 -0800
Message-ID: <m18wejvz9g.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> Eric W. Biederman wrote:
>> NFS does exactly the same thing I am doing.
>
> Oh... well, sysfs directories parenting other filesystems are pretty
> rare and well defined.  Although it's not very pretty, I don't think
> we'll see any actual problem there.  Thanks for the explanation.

To be perfectly clear, if we hit this ugly case.  The internal
sysfs_dirent tree is always what it should be.  Only the VFS dentry
cache doesn't get updated.

Eric
