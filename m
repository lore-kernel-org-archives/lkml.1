Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbYH1UGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbYH1UGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYH1UF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:05:57 -0400
Received: from styx.suse.cz ([82.119.242.94]:60351 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751887AbYH1UF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:05:57 -0400
Date: Thu, 28 Aug 2008 22:05:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: SLES10 SP1 (x86_64): Hard-hang when using NFSv4 from HP-UX
In-Reply-To: <48B6DF1E.7460.1183C391@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
Message-ID: <alpine.LNX.1.10.0808282151270.3822@jikos.suse.cz>
References: <48B69CE9.12245.108123EC@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>, <Pine.LNX.4.64.0808281336300.28540@twin.jikos.cz> <48B6DF1E.7460.1183C391@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Ulrich Windl wrote:

> > > Mounting the filesystems as NFSv3 causes no problems at all, using NFSv4 makes 
> > > every file open() attempt to hang hard. I must "kill -9" the processes. Even 
> > > "umount -vat nfs4" hangs on umount().
> > Sorry, but this mailinglist would be appropriate only if this happens 
> > still with current vanilla kernel.
> > Otherwise, you should report this problem to your vendor (Novell bugzilla 
> > in this case).
> (ingoring the fact your opinion may be influenced by SUSE/Novell)

In what sense? Do you think I am trying to direct as much bugs as possible 
our way? :)

> Are you saying that SUSE/Novell added bugs regarding NFS4 that are not 
> present in the vanilla kernel, or are you saying that the vanilla kernel 
> may have fixed NFSv4 bugs that SUSE/Novell did not fix? Why shouldn't 
> anybody be interested in the fact that there are problems?

linux-kernel malinglist is focused on vanilla kernel development. i.e. all 
the bugs that are present in the current version of the code are very 
welcome to be reported here.

SLES10 is based on 2.6.16 kernel, which has little interest for vanilla 
kernel developers. The bug you might be seeing could be caused by some 
SLES-specific patch (which is not probable, there are not many out-of-tree 
patches really), could have been fixed already a long time ago in upstream 
kernel version, or could be still present. Upstream kernel developers are 
interested only in the latest case. Otherwise, it's up to your distro 
kernel vendor to provide support.

-- 
Jiri Kosina
SUSE Labs
