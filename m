Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYAPToT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYAPToT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYAPToG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:44:06 -0500
Received: from hs-out-0708.google.com ([64.233.178.249]:2162 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751839AbYAPToF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:44:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LvXXbHekUWkAupfiLYs0zwVL6poL7ylbL0j2kibbSBrP7Cpi9KxtKK1EafCHkzFSYy2kU8RlB2ZN6/7nnyxWWeyGUaJsj6Jd+DMGQEDbXd8v5797DqrW+Tl7G2Jvzo5FC7DNBjwsQtwIJdF4/bXcLXqqICpt9SrD4552+IpXwFs=
Message-ID: <5bdc1c8b0801161144x62aa3f9bj868602db94b42570@mail.gmail.com>
Date: Wed, 16 Jan 2008 11:44:01 -0800
From: "Mark Knecht" <markknecht@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.24-rc7-rt3
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <1200456773.318.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200456773.318.14.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008 8:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> We are pleased to announce the 2.6.24-rc7-rt3 tree

Up and running here:

mark@lightning ~ $ uname -a
Linux lightning 2.6.24-rc7-rt3 #1 PREEMPT RT Wed Jan 16 11:06:11 PST
2008 x86_64 AMD Athlon(tm) 64 Processor 3000+ AuthenticAMD GNU/Linux
mark@lightning ~ $

Nothing of interest in dmesg. The issue I reported earlier about
/var/log/messages has been there for a long time without me noticing
it. I'm in 2.6.23-rt1 and I still see it so it has nothing to do with
the kernel as I'm sure you decided already.

Jan 16 11:12:55 lightning sshd[5915]: Server listening on :: port 22.
Jan 16 11:12:55 lightning sshd[5915]: error: Bind to port 22 on
0.0.0.0 failed: Address already in use.

Will continue testing as I get time.

Cheers,
Mark
