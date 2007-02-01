Return-Path: <linux-kernel-owner+w=401wt.eu-S1422937AbXBAU0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422937AbXBAU0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422988AbXBAU0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:26:36 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:37055 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422937AbXBAU0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:26:35 -0500
Date: Thu, 1 Feb 2007 21:26:34 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion  system calls
Message-ID: <20070201202633.GA14021@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
	linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <5bdda0f7bef20427f7e1.1170193185@tetsuo.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bdda0f7bef20427f7e1.1170193185@tetsuo.zabbo.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 01:39:45PM -0700, Zach Brown wrote:

> sys_asys_submit() is added to let userspace submit asynchronous system calls.
> It specifies the system call number and arguments.  A fibril is constructed for
> each call.  Each starts with a stack which executes the given system call
> handler and then returns to a function which records the return code of the
> system call handler.  sys_asys_await_completion() then lets userspace collect
> these results.

Zach,

Do you have any userspace code that can be used to get started experimenting
with your fibril based AIO stuff?

I want to try it on from a userspace perspective.

I'm confident I could hack it up from scratch, but I'm sure you'll have some
test code lying around.

I scanned the discussion so far, but I might've missed any references to
userspace code so far.

Thanks!

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
