Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZD2Fic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZD2Fic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZD2FiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:38:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbZD2FiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:38:22 -0400
Date: Tue, 28 Apr 2009 22:36:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
Message-Id: <20090428223624.61e7b255.akpm@linux-foundation.org>
In-Reply-To: <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>
	<20090427083935.GA20941@elte.hu>
	<21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 18:56:27 +1000 Dave Airlie <airlied@gmail.com> wrote:

> > KMS is the sane design for graphics and i'd go as far as to consider
> > user-space mode setting an outright _bug_. It look a long time to
> > fix but now lets look forward and fix all the bugs in KMS, ASAP ...
> 
> Its mainly for things like Andrews Vaio, people will not expect a new kernel
> to take out any current userspace, its a pain, but we assume distros + people
> who compile their own kernels will know what userspace exists on their
> machines and other will get the least surprise.

My Vaio thanks you.

What is the expected user-visible failure mode when someone enables KMS
on naive userspace?  iow, how can bug report screeners recognise when this has
happened?

