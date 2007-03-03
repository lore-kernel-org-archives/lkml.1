Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbXCCWTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbXCCWTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933134AbXCCWTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:19:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbXCCWTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:19:16 -0500
Message-ID: <45E9F454.2080600@redhat.com>
Date: Sat, 03 Mar 2007 17:19:00 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>	<45E9DD4A.2060806@redhat.com>	<20070303131204.6706a95c.akpm@linux-foundation.org>	<45E9E910.2070804@redhat.com>	<20070303214108.GA28961@outpost.ds9a.nl> <20070303141448.1ed70e6d.akpm@linux-foundation.org>
In-Reply-To: <20070303141448.1ed70e6d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 3 Mar 2007 22:41:09 +0100 bert hubert <bert.hubert@netherlabs.nl> wrote:
> 
>>> How can you make global policy decisions based on the intent
>>> of one program?
>> By not doing so.
> 
> yup.
> 
>> Andrew's program is fine in principle, except that the
>> linux kernel treats the communication of a program's intent as a global
>> instruction.
> 
> argh.
> 
> That felt good - let's do it again.
> 
> argh.
> 
> 
> It is *not* a global instruction.  It uses setenv, so the user's policy
> affects only the target process and its forked children.

... and all other processes accessing the same file(s)!

Your library and the system calls may be limited to one process,
but the consequences are global.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
