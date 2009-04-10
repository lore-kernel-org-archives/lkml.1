Return-Path: <linux-kernel-owner+w=401wt.eu-S934050AbZDJNA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050AbZDJNA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZDJNAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:00:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:20676 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZDJNAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nf89gDT7lX7WS6y/gli5v1Lo3j+5T4rLWP5bplRpos1U619mejD+8OO0670ZtLVM8Y
         E/akBBdutnPLrTTqLOUhUud07KrWCMKAY35arJbDSu8aWsMcKpQTpVgaR9perkbOuYY3
         0BHhSTvtwIIyuVUCfOobIHDRyYZ1+7hOFkUjk=
MIME-Version: 1.0
In-Reply-To: <200904101448.38166.rjw@sisk.pl>
References: <E1Ls9pZ-0004IF-FZ@closure.thunk.org>
	 <200904101448.38166.rjw@sisk.pl>
Date: Fri, 10 Apr 2009 21:00:08 +0800
Message-ID: <b6a2187b0904100600j261c4ea4l5e0f87a9fe0fe22c@mail.gmail.com>
Subject: Re: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/10 Rafael J. Wysocki <rjw@sisk.pl>:
> On Friday 10 April 2009, Theodore Ts'o wrote:
>> Hi, has anyone else noticed that suspend-to-ram seems to have gotten
>> broken in 2.6.30-rc1, sometime during last half of the merge window?

My X61 STR is broken as well.

> There was one similar report, but that issue should be fixed in 2.6.30-rc1
> if I remember correctly.
>
> Can you test commit 0a0c5168df270a50e3518e4f12bddb31f8f5f38f
> (PM: Introduce functions for suspending and resuming device interrupts), plaese?

This commit is in the latest git, but it's does not seem to fix the
problem. 2.6.29 STR works very well. And all the Think "Fn" keys are
no longer working (LID close still functioning though ... but that
could a configuration issue moving from 2.6.29 to 2.6.30-rc1.

Shall I do the bisecting? I think this is the only one not working for
me other than the slow iptables that I reported earlier.

Thanks,
Jeff.
