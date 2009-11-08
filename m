Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbZKHNPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbZKHNPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZKHNPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:15:44 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:51641 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZKHNPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:15:43 -0500
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] Removal of binary sysctl support
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <m13a4pjjh9.fsf@fess.ebiederm.org>
In-Reply-To: <m13a4pjjh9.fsf@fess.ebiederm.org>
Message-Id: <200911082215.HGJ57827.SJOVFFOHMOLFQt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 8 Nov 2009 22:15:46 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Eric W. Biederman wrote:
> 
> This patchset reimplements sys_sysctl as a compatibility wrapper
> around /proc/sys.  After which it removes all of the code to all over
> the kernel that is used today to implement the binary sysctls.
> 
> I am posting this patchset to give everyone a heads up what is in
> flight.
> 
> I intend to carry all of these patches in my sysctl tree.
> 
> If you add new sysctls to other trees please don't set the .ctl_name
> or .strategy fields in struct ctl_table, as setting those fields
> is unnecessary now and are removed by this patchset.

I have two questions.

Is there (or was there) an entry with ->procname == NULL ? (I thought so
because the loop condition is

	for ( ; table->ctl_name || table->procname; table++) {

.)

This patchset removes ->ctl_name on the assumption that ->procname != NULL ?

Regards.
