Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbYBUNXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbYBUNXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYBUNXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:23:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbYBUNXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:23:17 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [RESEND] [PATCH] fix invalidate_inode_pages2_range not to clear ret
References: <6.0.0.20.2.20080215132604.06091618@172.19.0.2>
	<x49mypv4i2d.fsf@segfault.boston.devel.redhat.com>
	<6.0.0.20.2.20080221111433.0394f1c8@172.19.0.2>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 21 Feb 2008 08:22:14 -0500
In-Reply-To: <6.0.0.20.2.20080221111433.0394f1c8@172.19.0.2> (Hisashi Hifumi's
	message of "Thu, 21 Feb 2008 11:23:20 +0900")
Message-ID: <x49ejb64f7d.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> writes:

> Hi Jeff.
>
>>
>>I agree with the patch (and I see Andrew already accepted it).  Do you
>>have a reproducer for this problem?
>
> Do you want to know the way of failing invalidate_complete_page2() ?

I was hoping for a test program that shows the problem.  Looking through
the previous threads on this subject, it seems that Zach may have had a
reproducer.  I tried running the aio-dio-regress tests on the 2.6.25-rc2
kernel, but was unable to trigger this problem.

-Jeff
