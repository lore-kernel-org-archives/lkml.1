Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbYAHX4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbYAHX4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYAHX41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:56:27 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:51456 "EHLO
	server1.example.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752521AbYAHX4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:56:25 -0500
Message-ID: <47840DAC.5000108@nigel.suspend2.net>
Date: Wed, 09 Jan 2008 10:56:28 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: pavel@ucw.cz, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, ebiederm@xmission.com,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [patch 7/9] unprivileged mounts: allow unprivileged fuse mounts
References: <20080108113502.184459371@szeredi.hu> <20080108113630.861045063@szeredi.hu> <20080108214625.GE5050@ucw.cz> <E1JCN9I-0004DB-DF@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JCN9I-0004DB-DF@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Miklos Szeredi wrote:
>> On Tue 2008-01-08 12:35:09, Miklos Szeredi wrote:
>>> From: Miklos Szeredi <mszeredi@suse.cz>
>>>
>>> Use FS_SAFE for "fuse" fs type, but not for "fuseblk".
>>>
>>> FUSE was designed from the beginning to be safe for unprivileged users.  This
>>> has also been verified in practice over many years.  In addition unprivileged
>> Eh? So 'kill -9 no longer works' and 'suspend no longer works' is not
>> considered important enough to even mention?
> 
> No.  Because in practice they don't seem to matter.  Also because
> there's no way in which fuse could be done differently to address
> these issues.

Could you clarify, please? I hope I'm getting the wrong end of the stick
- it sounds to me like you and Pavel are saying that this patch breaks
suspending to ram (and hibernating?) but you want to push it anyway
because you haven't been able to produce an instance, don't think
suspending or hibernating matter and couldn't fix fuse anyway?

> The 'kill -9' thing is basically due to VFS level locking not being
> interruptible.  It could be changed, but I'm not sure it's worth it.
> 
> For the suspend issue, there are also no easy solutions.

What are the non-easy solutions?

Regards,

Nigel
