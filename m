Return-Path: <linux-kernel-owner+w=401wt.eu-S934120AbXHXDOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120AbXHXDOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 23:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXHXDOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 23:14:38 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36476 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbXHXDOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 23:14:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, samuel@sortiz.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1 - irda goes belly up
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<23568.1187876026@turing-police.cc.vt.edu>
	<20070823141652.d488a6e0.akpm@linux-foundation.org>
Date: Thu, 23 Aug 2007 21:11:48 -0600
In-Reply-To: <20070823141652.d488a6e0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 23 Aug 2007 14:16:52 -0700")
Message-ID: <m1hcmpoccr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Cute.  Eric, can you please suggest what we should do here?

Grumble.

Ok.   This is a two sided bug.
The NET_IRDA define as not put in sysctl.h where it belongs so I
missed it, when making the list of all existing binary sysctls.

So really I need to put update the sysctl_check tables to have
the NET_IRDA numbers, because at least at first skim everything
looks ok on the binary side.

Patches to follow shortly.

Eric
