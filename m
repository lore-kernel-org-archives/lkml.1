Return-Path: <linux-kernel-owner+w=401wt.eu-S1031254AbXDUOM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031254AbXDUOM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 10:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031253AbXDUOM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 10:12:26 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60139 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031243AbXDUOMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 10:12:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 7/8] allow unprivileged mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102652.075606533@szeredi.hu>
	<20070421005513.e230aa88.akpm@linux-foundation.org>
Date: Sat, 21 Apr 2007 08:10:18 -0600
In-Reply-To: <20070421005513.e230aa88.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sat, 21 Apr 2007 00:55:13 -0700")
Message-ID: <m1bqhhked1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 20 Apr 2007 12:25:39 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> Define a new fs flag FS_SAFE, which denotes, that unprivileged
>> mounting of this filesystem may not constitute a security problem.
>> 
>> Since most filesystems haven't been designed with unprivileged
>> mounting in mind, a thorough audit is needed before setting this flag.
>
> Practically speaking, is there any realistic likelihood that any filesystem
> apart from FUSE will ever use this?

Also potentially some of the kernel virtual filesystems.  /proc should
be safe already.  If you don't have any kind of backing store this problem
gets easier.

With unprivileged users allowed to create mounts the utility of kernel
functionality exported as filesystems goes up quite a bit.  We are not
plan9 but this is the last bottleneck in allowing the everything is
a filesystem paradigm from being really usable in linux.

Eric
