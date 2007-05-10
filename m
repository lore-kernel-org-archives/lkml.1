Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbXEJShc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbXEJShc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXEJSh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:37:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbXEJShZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:37:25 -0400
Message-ID: <464363DC.7060607@redhat.com>
Date: Thu, 10 May 2007 11:26:36 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <17969.22692.855242.359680@notabene.brown> <46315C61.30001@redhat.com>
In-Reply-To: <46315C61.30001@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> Neil Brown wrote:
>> Does it also specify how to find out what granularity is used by the
>> filesystem?  I had a need for this just recently and couldn't see any
>> way to extract it.
> 
> That's still on the table.  We might end up with an fpathconf() solution.

OK, the pathconf()-based solution will most probably be in the next 
POSIX spec.

Now, somebody has to provide a way to get to this information.  The 
kernel does not export it so far.  Is it finally time to break down and 
allow pathconf() and fpathconf() syscalls into the kernel?

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
