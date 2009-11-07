Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbZKGCQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbZKGCQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 21:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZKGCQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 21:16:37 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58224 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbZKGCQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 21:16:37 -0500
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
	<4AF4D76C.6090008@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 06 Nov 2009 18:16:29 -0800
In-Reply-To: <4AF4D76C.6090008@kernel.org> (Tejun Heo's message of "Sat\, 07 Nov 2009 11\:11\:56 +0900")
Message-ID: <m1y6mjw03m.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> Eric W. Biederman wrote:
>> It isn't what I want but it is what the VFS requires.  If let the vfs
>> continue on it's delusional state we will leak the vfs mount and
>> everything mounted on top of it, with no way to remove the mounts.
>
> This is caused by not having any way to prevent deletion on
> directories with submounts, right?  How does other distributed
> filesystems deal with directories with submounts going away underneath
> it?

NFS does exactly the same thing I am doing.

Eric
