Return-Path: <linux-kernel-owner+w=401wt.eu-S1030491AbXCCW24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030491AbXCCW24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030499AbXCCW24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:28:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030491AbXCCW2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:28:55 -0500
Message-ID: <45E9F693.3060200@redhat.com>
Date: Sat, 03 Mar 2007 17:28:35 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>	<45E9DD4A.2060806@redhat.com>	<20070303131204.6706a95c.akpm@linux-foundation.org>	<45E9E910.2070804@redhat.com>	<20070303214108.GA28961@outpost.ds9a.nl>	<20070303141448.1ed70e6d.akpm@linux-foundation.org>	<45E9F454.2080600@redhat.com> <20070303142609.d3bc9cc3.akpm@linux-foundation.org>
In-Reply-To: <20070303142609.d3bc9cc3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 03 Mar 2007 17:19:00 -0500 Rik van Riel <riel@redhat.com> wrote:
> 
>>> It is *not* a global instruction.  It uses setenv, so the user's policy
>>> affects only the target process and its forked children.
>> ... and all other processes accessing the same file(s)!
>>
>> Your library and the system calls may be limited to one process,
>> but the consequences are global.
> 
> Yes.  So what?  If the user wants to go and evict libc.so from pagecache
> then he can do so - the kernel has provided syscalls with which this can be
> done for at least seven years.  Bad user, shouldn't do that.

Are you saying the user should not use your script with their
backup program?

Then what's the point?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
