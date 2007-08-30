Return-Path: <linux-kernel-owner+w=401wt.eu-S933240AbXH3S6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240AbXH3S6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932496AbXH3S6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:58:14 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48209 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbXH3S6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:58:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Hellwig <hch@infradead.org>
Cc: Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>
	<46D4CC81.4060400@zytor.com> <200708301432.11516.rob@landley.net>
	<20070830183402.GA17084@infradead.org>
Date: Thu, 30 Aug 2007 12:57:29 -0600
In-Reply-To: <20070830183402.GA17084@infradead.org> (Christoph Hellwig's
	message of "Thu, 30 Aug 2007 19:34:02 +0100")
Message-ID: <m17inczw86.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Aug 30, 2007 at 02:32:11PM -0500, Rob Landley wrote:
>> (If sysctlfs wasn't part of proc, that would be less of an issue, but we need
>> union mounts for that...)
>
> Not at all.  all sysctls are under /proc/sys/

Yes.  So all we really need to do is split them apart and do the nfs multiple
mount thing to maintain backwards compatibility when mounting proc.

The code is close enough to split apart now that it probably would not be
to difficult to finish the job.

Eric
