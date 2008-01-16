Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYAPCTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYAPCTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYAPCSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:18:54 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:35293 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754293AbYAPCSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:18:53 -0500
Message-ID: <400449941.28506@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 16 Jan 2008 10:18:48 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Michael Rubin <mrubin@google.com>
Cc: Andrew Morton <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] writeback bug fixes and simplifications take 2
References: <400401292.24795@ustc.edu.cn> <532480950801151033w69411f8dk4d9ab14a2ff07d64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532480950801151033w69411f8dk4d9ab14a2ff07d64@mail.gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JExrc-00014E-FC@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 10:33:01AM -0800, Michael Rubin wrote:
> On Jan 15, 2008 4:36 AM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > Andrew,
> >
> > This patchset mainly polishes the writeback queuing policies.
> 
> Anyone know which tree is this patched based out of?

They are against the latest -mm tree, or 2.6.24-rc6-mm1.

> > The main goals are:
> >
> > (1) small files should not be starved by big dirty files
> > (2) sync as fast as possible for not-blocked inodes/pages
> >     - don't leave them out; no congestion_wait() in between them
> > (3) avoid busy iowait for blocked inodes
> >     - retry them in the next go of s_io(maybe at the next wakeup of pdflush)
> >
> 
> Fengguang do you have any specific tests for any of these cases? As I
> have posted earlier I am putting together a writeback test suite for
> test.kernel.org and if you have one (even if it's an ugly shell
> script) that would save me some time.

No, I just run tests with cp/dd etc.  I analyze the code and debug
traces a lot, and know that it works in the situations I can imagine.
But dedicated test suites are good in the long term.

> Also if you want any of mine let me know. :-)

OK, thank you.

Fengguang

