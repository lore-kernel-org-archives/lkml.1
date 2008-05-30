Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYE3RV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYE3RV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 13:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYE3RVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 13:21:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbYE3RVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 13:21:19 -0400
Date: Fri, 30 May 2008 13:14:32 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Rsync cannot copy to a vfat partition on kernel 2.6.25
Message-ID: <20080530171432.GA32480@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
References: <bug-449080-176318@bugzilla.redhat.com> <200805301659.m4UGx3AW001503@bz-web2.app.phx.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805301659.m4UGx3AW001503@bz-web2.app.phx.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had a user report at https://bugzilla.redhat.com/show_bug.cgi?id=449080
that in 2.6.25, he can no longer rsync to a vfat partition, even as root.
I just reproduced this here. It gets -EPERM in the mkstemp call.
(full strace in the bug report).

Did we change behaviour somehow in the vfat code?
2.6.24.7 works fine apparently.

	Dave

-- 
http://www.codemonkey.org.uk
