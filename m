Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbXDURUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbXDURUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 13:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXDURUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 13:20:35 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:39804 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbXDURUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 13:20:34 -0400
Date: Sat, 21 Apr 2007 19:10:55 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 7/8] allow unprivileged mounts
In-Reply-To: <m1zm51is2h.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.61.0704211905230.9989@yvahk01.tjqt.qr>
References: <20070420102532.385211890@szeredi.hu> <20070420102652.075606533@szeredi.hu>
 <20070421005513.e230aa88.akpm@linux-foundation.org> <m1bqhhked1.fsf@ebiederm.dsl.xmission.com>
 <Pine.LNX.4.61.0704211743100.9989@yvahk01.tjqt.qr> <m1zm51is2h.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 21 2007 10:57, Eric W. Biederman wrote:
>
>> tmpfs!
>
>tmpfs is a possible problem because it can consume lots of ram/swap. 
>Which is why it has limits on the amount of space it can consume. 

Users can gobble up all RAM and swap already today. (Unless they are
confined into an rlimit, which, in most systems, is not the case.)
And in case /dev/shm exists, they can already fill it without running
into an rlimit early.

>Those are set as mount options as I recall.  Which means that we
>would need to do something different with respect to limits before
>tmpfs could become safe for an untrusted user to mount.
>
>Still it's close.


Jan
-- 
