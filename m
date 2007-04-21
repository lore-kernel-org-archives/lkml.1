Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbXDUP7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbXDUP7l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 11:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXDUP7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 11:59:41 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:43529 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbXDUP7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 11:59:40 -0400
Date: Sat, 21 Apr 2007 17:43:28 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 7/8] allow unprivileged mounts
In-Reply-To: <m1bqhhked1.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.61.0704211743100.9989@yvahk01.tjqt.qr>
References: <20070420102532.385211890@szeredi.hu> <20070420102652.075606533@szeredi.hu>
 <20070421005513.e230aa88.akpm@linux-foundation.org> <m1bqhhked1.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 21 2007 08:10, Eric W. Biederman wrote:
>>
>>> Define a new fs flag FS_SAFE, which denotes, that unprivileged
>>> mounting of this filesystem may not constitute a security problem.
>>> 
>>> Since most filesystems haven't been designed with unprivileged
>>> mounting in mind, a thorough audit is needed before setting this flag.
>>
>> Practically speaking, is there any realistic likelihood that any filesystem
>> apart from FUSE will ever use this?
>
>Also potentially some of the kernel virtual filesystems.  /proc should
>be safe already.  If you don't have any kind of backing store this problem
>gets easier.

tmpfs!


Jan
-- 
