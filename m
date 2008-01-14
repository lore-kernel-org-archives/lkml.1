Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYANUCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYANUCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYANUC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 15:02:26 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:50780 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbYANUCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 15:02:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=v8/YzaKsADzr90/Z2mZxui14beXjUQc8dmWUEW9mXZhA25manV58Cp5AhwVrEz9U1xBUnq2imEjYDp2bzHzCJ7OsWCiU9Yxb09e59YmYmTyC0zb3q5web2BDpzl9fYNZA1Ahn2esDVskmNDx53naDTBclEMcsrIFIYHdZ+j1mc0=
Message-ID: <5bdc1c8b0801141202p68dcb452yd2cb55fde9336521@mail.gmail.com>
Date: Mon, 14 Jan 2008 12:02:21 -0800
From: "Mark Knecht" <markknecht@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.24-rc7-rt2
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <1200336080.318.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200336080.318.8.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 10:41 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> We are pleased to announce the 2.6.24-rc7-rt2 tree, which can be
> downloaded from the location:
>

Up and running here:

mark@lightning ~ $ uname -a
Linux lightning 2.6.24-rc7-rt2 #1 PREEMPT RT Mon Jan 14 11:18:04 PST
2008 x86_64 AMD Athlon(tm) 64 Processor 3000+ AuthenticAMD GNU/Linux
mark@lightning ~ $

I must learn how to use some of the test tools so I can do better
testing for you guys. I see no problems in dmesg but in
/var/log/messages I spotted this:

Jan 14 11:56:54 lightning sshd[5915]: Server listening on :: port 22.
Jan 14 11:56:54 lightning sshd[5915]: error: Bind to port 22 on
0.0.0.0 failed: Address already in use.

Scanning back through /var/log/messages I don't see that in earlier kernels.

- Mark
