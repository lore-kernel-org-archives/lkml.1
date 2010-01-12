Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556Ab0ALAjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0ALAjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532Ab0ALAjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:39:41 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:62068 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab0ALAji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:39:38 -0500
Date: Mon, 11 Jan 2010 16:38:03 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: Fix refcnt leak on ocfs2_fast_follow_link()
 error path
Message-ID: <20100112003803.GC20285@mail.oracle.com>
Mail-Followup-To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <87eilwjxmu.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eilwjxmu.fsf@devron.myhome.or.jp>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B4BC4B8.0092:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 03:37:45AM +0900, OGAWA Hirofumi wrote:
> 
> If ->follow_link handler return the error, it should decrement
> nd->path refcnt. But, ocfs2_fast_follow_link() doesn't decrement.
> 
> This patch fix it by using usual nd_set_link() style error handling,
> instead of playing with nd->path.
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"Against stupidity the Gods themselves contend in vain."
	- Friedrich von Schiller

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
