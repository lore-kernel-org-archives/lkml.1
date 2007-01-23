Return-Path: <linux-kernel-owner+w=401wt.eu-S965481AbXAWVfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965481AbXAWVfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 16:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965489AbXAWVfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 16:35:15 -0500
Received: from colo.lackof.org ([198.49.126.79]:37914 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965488AbXAWVfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 16:35:13 -0500
Date: Tue, 23 Jan 2007 14:35:04 -0700
From: dann frazier <dannf@dannf.org>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, Santiago Garcia Mantinan <manty@debian.org>,
       linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: problems with latest smbfs changes on 2.4.34 and security backports
Message-ID: <20070123213503.GF26310@colo>
References: <20070117100030.GA11251@clandestino.aytolacoruna.es> <20070117215519.GX24090@1wt.eu> <20070119010040.GR16053@colo> <20070120010544.GY26210@colo> <t1r7r2thimh3gpuhtfc9l3aehjdd6dqkp8@4ax.com> <20070121230321.GC2480@1wt.eu> <20070123201936.GA26310@colo> <mstcr2hm6aar4t58o3gm0hit6thpdd6ohp@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mstcr2hm6aar4t58o3gm0hit6thpdd6ohp@4ax.com>
User-Agent: mutt-ng/devel-r782 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 08:04:36AM +1100, Grant Coady wrote:
> Hi Dann,
> I'm running slackware-11, no smbfs package, 'smbmnt' is from samba-3.0.23c 
> package with two tiny unrelated (?) patches:

Thanks again Grant. You might check out the patch I just submitted -
turns out this was an issue that was already fixed in 2.6, and that
fix is more complete than my previous one. You'll need the additional
userspace patches to use the server-provided perms (i.e., get rid of
the +x bits).

-- 
dann frazier

