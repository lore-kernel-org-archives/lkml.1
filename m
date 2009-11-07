Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZKGCME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZKGCME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 21:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZKGCME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 21:12:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:42861 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbZKGCMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 21:12:02 -0500
Message-ID: <4AF4D76C.6090008@kernel.org>
Date: Sat, 07 Nov 2009 11:11:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 12/13] sysfs: Propagate renames to the vfs on demand
References: <m13a4vbz8r.fsf@fess.ebiederm.org>	<1257249429-12384-12-git-send-email-ebiederm@xmission.com>	<20091104214938.GA21033@us.ibm.com> <m13a4ux86v.fsf@fess.ebiederm.org>
In-Reply-To: <m13a4ux86v.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Eric W. Biederman wrote:
> It isn't what I want but it is what the VFS requires.  If let the vfs
> continue on it's delusional state we will leak the vfs mount and
> everything mounted on top of it, with no way to remove the mounts.

This is caused by not having any way to prevent deletion on
directories with submounts, right?  How does other distributed
filesystems deal with directories with submounts going away underneath
it?

Thanks.

-- 
tejun
