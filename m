Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYC2So4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYC2So4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYC2Sos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:44:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:25818 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbYC2Sor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oEq9nhEKRRAMBnebUKg7XjiulZxDPiy8vUUdFp9cTkajgtRbCnGRvHi1kOuPtYgRHv1IQhDo7ShUBdHf9/FHA1mMFa8jtmcEfz0luuWcDZdpiUp2S6ZlKBatxSPKn/OPVRaqLSBqnP+2V35OZOaFF8yS+vi/MIebUMQ8PerOBhE=
Subject: Re: [PATCH] NULL noise: fs/*, mm/*, kernel/*
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <E1JfRPk-0002Vz-Hp@ZenIV.linux.org.uk>
References: <E1JfRPk-0002Vz-Hp@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sat, 29 Mar 2008 11:44:53 -0700
Message-Id: <1206816293.6543.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-29 at 03:07 +0000, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/reiserfs/do_balan.c |    8 ++++----
>  fs/reiserfs/fix_node.c |    8 +++++---
>  fs/reiserfs/lbalance.c |    2 +-
>  fs/reiserfs/namei.c    |    2 +-

reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch

All covered in -mm already

>  fs/smbfs/smbiod.c      |    2 +-

Thought I sent this, but can't find it in the -mm lineup

>  kernel/cgroup.c        |    4 ++--
>  kernel/futex.c         |    2 +-
>  mm/sparse-vmemmap.c    |    8 ++++----

Thought I sent this too, but can't find it in the -mm lineup.

Suggest applying the non-reiser parts and let the -mm stuff go
in for 2.6.26.


Cheers,

Harvey

