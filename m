Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583Ab0ABG2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab0ABG2I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 01:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536Ab0ABG2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 01:28:07 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:50919 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab0ABG2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 01:28:06 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: RFC: disablenetwork facility. (v4)
Date: Sat, 2 Jan 2010 06:28:04 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hhmp1k$oc$1@taverner.cs.berkeley.edu>
References: <m1y6km11lj.fsf@fess.ebiederm.org> <hhev6r$n8b$1@taverner.cs.berkeley.edu> <m1ws02hx1k.fsf@fess.ebiederm.org>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1262413684 780 128.32.153.193 (2 Jan 2010 06:28:04 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sat, 2 Jan 2010 06:28:04 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>daw@cs.berkeley.edu (David Wagner) writes:
>> When you talk about DOS, let's be a bit more precise.  disablenetwork
>> gives a way to deny setuid programs access to the network.  It's not a
>> general-purpose DOS; it's denying access to the network only.  And the
>> network is fundamentally unreliable.  No security-critical mechanism
>> should be relying upon the availability of the network.
>
>The audit daemon should not rely on netlink?

auditd is not a setuid-root program.  It is launched at boot time.
(If that's what you're referring to.)

I'm personally not very worried about attacks on a setuid-root program
that leave it unable to log messages to the audit log.  I personally
find it hard to get very concerned about that scenario.  And if there
is a setuid-root program where it is absolutely vital that the log
messages get through, then the setuid-root program probably ought to
be checking return values and acknowledgements anyway, regardless of
whether disablenetwork is in place or not.

>For me the case is simple.  I have seen several plausible sounding
>scenarios that get most of the way there.  I know I am stupid when
>it comes to security and that people exploiting problems are going
>to be looking harder than I will.  Therefore I think there is
>a reasonable chance this will introduce a security hole for someone.

OK.  I'm not opposed to introducing some way to disable setuid
execution, to give folks a greater comfort level.  I still am not
convinced it's necessary (I personally suspect it to be unnecessary),
but if it is the necessary political compromise to enable the Linux
kernel to better support privilege separation and sandboxing,
so be it.  Whatever it takes to get that support in place is
worthwhile.  So, thank you for working out how to implement such
a mechanism!
