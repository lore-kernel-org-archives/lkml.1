Return-Path: <linux-kernel-owner+w=401wt.eu-S932790AbXIBVwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbXIBVwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 17:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbXIBVw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 17:52:27 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39691 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbXIBVw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 17:52:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<200709020344.51437.rob@landley.net> <46DA7A4C.6080501@zytor.com>
	<200709020605.00782.rob@landley.net>
	<m1d4x0zvri.fsf@ebiederm.dsl.xmission.com>
	<20070902200010.GS21089@ftp.linux.org.uk>
Date: Sun, 02 Sep 2007 15:51:29 -0600
In-Reply-To: <20070902200010.GS21089@ftp.linux.org.uk> (Al Viro's message of
	"Sun, 2 Sep 2007 21:00:10 +0100")
Message-ID: <m18x7ozqfy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> writes:

> On Sun, Sep 02, 2007 at 01:56:33PM -0600, Eric W. Biederman wrote:
>> - I think all that is left is superblock handling and some backward
>>   compatibility magic. (Using the follow_link trick to automatically
>>   mount /proc/sys)
>
> NAK.  Let's explicitly mount this stuff in init scripts; it won't break
> on older kernels and there's no excuse for that kind of kludges in the
> kernel.

I don't much care.   But we do have the infrastructure for it in the
kernel and NFS uses it.  And it seems like a nice way to preserve user
space backwards compatibility, without making the code to nasty.

If we don't mind that bit of change that would make it harder to
upgrade a kernel I don't mind not doing it.  It just looks like a
elegant way to handle that implementation change.

Eric
